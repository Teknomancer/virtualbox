/* $Id: xmmsaving.cpp 114156 2026-05-20 08:54:03Z knut.osmundsen@oracle.com $ */
/** @file
 * xmmsaving - Test that all XMM register state is handled correctly and
 *             not corrupted the VMM.
 */

/*
 * Copyright (C) 2009-2026 Oracle and/or its affiliates.
 *
 * This file is part of VirtualBox base platform packages, as
 * available from https://www.virtualbox.org.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, in version 3 of the
 * License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses>.
 *
 * The contents of this file may alternatively be used under the terms
 * of the Common Development and Distribution License Version 1.0
 * (CDDL), a copy of it is provided in the "COPYING.CDDL" file included
 * in the VirtualBox distribution, in which case the provisions of the
 * CDDL are applicable instead of those of the GPL.
 *
 * You may elect to license modified versions of this file under the
 * terms and conditions of either the GPL or the CDDL or both.
 *
 * SPDX-License-Identifier: GPL-3.0-only OR CDDL-1.0
 */


/*********************************************************************************************************************************
*   Header Files                                                                                                                 *
*********************************************************************************************************************************/
#include <iprt/buildconfig.h>
#include <iprt/cpuset.h>
#include <iprt/getopt.h>
#include <iprt/mem.h>
#include <iprt/message.h>
#include <iprt/process.h>
#include <iprt/stream.h>
#include <iprt/test.h>
#include <iprt/thread.h>
#include <iprt/x86.h>


/*********************************************************************************************************************************
*   Structures and Typedefs                                                                                                      *
*********************************************************************************************************************************/
typedef struct MYXMMREGSET
{
    RTUINT128U  aRegs[16];
} MYXMMREGSET;


/*********************************************************************************************************************************
*   Global Variables                                                                                                             *
*********************************************************************************************************************************/
static RTTEST   g_hTest;
static uint32_t g_cSets          = 256;
static uint64_t g_cMaxIterations = 1000000;
static RTTHREAD g_ahThreads[RTCPUSET_MAX_CPUS];


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
DECLASM(int) XmmSavingTestLoadSet(const MYXMMREGSET *pSet, const MYXMMREGSET *pPrevSet, PRTUINT128U pBadVal);


static DECLCALLBACK(int) XmmSavingTest(RTTHREAD hThreadSelf, void *pvUser)
{
    uintptr_t const idxThread = (uintptr_t)pvUser;
    RT_NOREF(hThreadSelf);

    /* Create the test sets. */
    MYXMMREGSET * const paSets = (MYXMMREGSET *)RTMemAllocZ(sizeof(paSets[0]) * g_cSets);
    RTTEST_CHECK_RET(g_hTest, paSets, VERR_NO_MEMORY);

    for (unsigned s = 0; s < g_cSets; s++)
        for (unsigned r = 0; r < RT_ELEMENTS(paSets[s].aRegs); r++)
        {
            unsigned x = (s << 4) | (r + (unsigned)idxThread);
            paSets[s].aRegs[r].au32[0] =  x        | UINT32_C(0x12345000);
            paSets[s].aRegs[r].au32[1] = (x << 8)  | UINT32_C(0x88700011);
            paSets[s].aRegs[r].au32[2] = (x << 16) | UINT32_C(0xe000dcba);
            paSets[s].aRegs[r].au32[3] = (x << 20) | UINT32_C(0x00087654);
        }

    /* Do the actual testing. */
    const MYXMMREGSET *pPrev2 = NULL;
    const MYXMMREGSET *pPrev = NULL;
    for (uint64_t i = 1; i <= g_cMaxIterations; i++)
    {
        if ((i & 0xffff) == 0 && idxThread == 0)
        {
            RTTestPrintf(g_hTest, RTTESTLVL_ALWAYS, ".");
            pPrev = pPrev2 = NULL; /* May be trashed by the above call. */
        }
        for (unsigned s = 0; s < g_cSets; s++)
        {
            RTUINT128U         BadVal;
            const MYXMMREGSET *pSet = &paSets[s];
            int r = XmmSavingTestLoadSet(pSet, pPrev, &BadVal);
            if (r-- != 0)
            {
                RTTestFailed(g_hTest, "%zu: i=%llu s=%d r=%d", idxThread, i, s, r);
                RTTestFailureDetails(g_hTest, "%zu: XMM%-2d  = %08x,%08x,%08x,%08x\n",
                                     idxThread,
                                     r,
                                     BadVal.au32[0],
                                     BadVal.au32[1],
                                     BadVal.au32[2],
                                     BadVal.au32[3]);
                RTTestFailureDetails(g_hTest, "%zu: Expected %08x,%08x,%08x,%08x\n",
                                     idxThread,
                                     pPrev->aRegs[r].au32[0],
                                     pPrev->aRegs[r].au32[1],
                                     pPrev->aRegs[r].au32[2],
                                     pPrev->aRegs[r].au32[3]);
                if (pPrev2)
                    RTTestFailureDetails(g_hTest, "%zu: PrevPrev %08x,%08x,%08x,%08x\n",
                                         idxThread,
                                         pPrev2->aRegs[r].au32[0],
                                         pPrev2->aRegs[r].au32[1],
                                         pPrev2->aRegs[r].au32[2],
                                         pPrev2->aRegs[r].au32[3]);
                RTMemFree(paSets);
                return VERR_GENERAL_FAILURE;
            }
            pPrev2 = pPrev;
            pPrev = pSet;
        }
    }

    RTMemFree(paSets);
    return VINF_SUCCESS;
}


int main(int argc, char **argv)
{
    int rc = RTTestInitExAndCreate(argc, &argv, 0, "xmmsaving", &g_hTest);
    if (rc)
        return rc;

    static const RTGETOPTDEF s_aOptions[] =
    {
        { "--iterations",       'i', RTGETOPT_REQ_UINT64  },
        { "--infinite",         'I', RTGETOPT_REQ_NOTHING },
        { "--sets",             's', RTGETOPT_REQ_UINT32  },
        { "--threads",          't', RTGETOPT_REQ_UINT32  },
    };
    uint32_t cThreads = 1;

    RTGETOPTUNION ValueUnion;
    RTGETOPTSTATE GetState;
    RTGetOptInit(&GetState, argc, argv, s_aOptions, RT_ELEMENTS(s_aOptions), 1, 0);
    while ((rc = RTGetOpt(&GetState, &ValueUnion)))
    {
        switch (rc)
        {
            case 'i':
                g_cMaxIterations = ValueUnion.u64;
                break;
            case 'I':
                g_cMaxIterations = UINT64_MAX;
                break;
            case 's':
                if (ValueUnion.u32 < 2 || ValueUnion.u32 > _32K)
                    return RTMsgSyntax("Number of sets is out of range: %u, valid range [2..%u]", ValueUnion.u32, _32K);
                g_cSets = ValueUnion.u32;
                break;
            case 't':
                if (ValueUnion.u32 < 1 || ValueUnion.u32 > RTCPUSET_MAX_CPUS)
                    return RTMsgSyntax("Number of threads is out of range: %u, valid range [1..%u]",
                                       ValueUnion.u32, RTCPUSET_MAX_CPUS);
                cThreads = ValueUnion.u32;
                break;
            case 'h':
                RTPrintf("usage: %s [--iterations|-i <n>] [--infinite|-I] [--sets|-s <n>] [--threads|-t <n>]\n",
                         RTProcShortName());
                return RTEXITCODE_SUCCESS;
            case 'V':
                RTPrintf("%sr%u\n", RTBldCfgVersion(), RTBldCfgRevision());
                return RTEXITCODE_SUCCESS;
            default:
                return RTGetOptPrintError(rc, &ValueUnion);
        }
    }

    RTTestISub("xmm saving and restoring");
    uintptr_t iThread;
    for (iThread = 1; iThread < cThreads; iThread++)
    {
        rc = RTThreadCreateF(&g_ahThreads[iThread], XmmSavingTest, (void *)iThread, 0,
                             RTTHREADTYPE_DEFAULT, RTTHREADFLAGS_WAITABLE, "xmm%u", iThread);
        RTTESTI_CHECK_RC_OK_BREAK(rc);
    }
    if (iThread > 1)
        RTTestPrintf(g_hTest, RTTESTLVL_ALWAYS, "Started %zu additional thread%s.\n", iThread - 1, iThread - 1 == 1 ? "" : "s");
    XmmSavingTest(RTThreadSelf(), NULL);
    while (iThread-- > 1)
        RTTESTI_CHECK_RC_OK(RTThreadWait(g_ahThreads[iThread], RT_MS_30SEC, NULL));

    return RTTestSummaryAndDestroy(g_hTest);
}

