/* $Id: tstNATLibslirpVBox.cpp 114518 2026-06-25 08:29:23Z andreas.loeffler@oracle.com $ */
/** @file
 * NAT libslirp VBox testcase.
 */

/*
 * Copyright (C) 2026 Oracle and/or its affiliates.
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
 * SPDX-License-Identifier: GPL-3.0-only
 */


/*********************************************************************************************************************************
*   Header Files                                                                                                                 *
*********************************************************************************************************************************/
#ifdef RT_OS_WINDOWS
# include <iprt/win/winsock2.h>
# include <iprt/win/ws2tcpip.h>
# include <iprt/win/windows.h>
#endif

#include <slirp/libslirp.h>

#include <iprt/cdefs.h>
#include <iprt/errcore.h>
#include <iprt/mem.h>
#include <iprt/net.h>
#include <iprt/string.h>
#include <iprt/test.h>

#include <string.h>




static DECLCALLBACK(slirp_ssize_t) tstSendPacket(const void *pvBuf, ssize_t cbBuf, void *pvOpaque)
{
    RT_NOREF(pvBuf, pvOpaque);
    return cbBuf;
}


static DECLCALLBACK(void) tstGuestError(const char *pszMsg, void *pvOpaque)
{
    RT_NOREF(pszMsg, pvOpaque);
}


static DECLCALLBACK(int64_t) tstClockGetNs(void *pvOpaque)
{
    RT_NOREF(pvOpaque);
    return 0;
}


static DECLCALLBACK(void *) tstTimerNew(SlirpTimerCb pfnTimer, void *pvTimerOpaque, void *pvOpaque)
{
    RT_NOREF(pfnTimer, pvTimerOpaque, pvOpaque);
    return (void *)(uintptr_t)1;
}


static DECLCALLBACK(void) tstTimerFree(void *pvTimer, void *pvOpaque)
{
    RT_NOREF(pvTimer, pvOpaque);
}


static DECLCALLBACK(void) tstTimerMod(void *pvTimer, int64_t nsExpire, void *pvOpaque)
{
    RT_NOREF(pvTimer, nsExpire, pvOpaque);
}


static struct in_addr tstParseIPv4(const char *pszAddr)
{
    RTNETADDRIPV4 ParsedAddr;
    int rc = RTNetStrToIPv4Addr(pszAddr, &ParsedAddr);
    if (RT_FAILURE(rc))
        RTTestIFailed("RTNetStrToIPv4Addr failed for '%s': %Rrc", pszAddr, rc);

    struct in_addr Addr;
    RT_ZERO(Addr);
    Addr.s_addr = RT_SUCCESS(rc) ? ParsedAddr.u : 0;
    return Addr;
}


static struct in6_addr tstParseIPv6(const char *pszAddr)
{
    RTNETADDRIPV6 ParsedAddr;
    char *pszZone = NULL;
    int rc = RTNetStrToIPv6Addr(pszAddr, &ParsedAddr, &pszZone);
    if (RT_FAILURE(rc))
        RTTestIFailed("RTNetStrToIPv6Addr failed for '%s': %Rrc", pszAddr, rc);

    struct in6_addr Addr;
    RT_ZERO(Addr);
    if (RT_SUCCESS(rc))
        memcpy(&Addr, &ParsedAddr, sizeof(Addr));
    return Addr;
}


static struct in_addr *tstDupInAddr(const char *pszAddr)
{
    struct in_addr Addr = tstParseIPv4(pszAddr);
    return (struct in_addr *)RTMemDup(&Addr, sizeof(Addr));
}


static struct in6_addr *tstDupIn6Addr(const char *pszAddr)
{
    struct in6_addr Addr = tstParseIPv6(pszAddr);
    return (struct in6_addr *)RTMemDup(&Addr, sizeof(Addr));
}


static void tstVBoxAbi(void)
{
    RTTestISub("ABI: VBox-only SlirpConfig fields");

    struct ip4_lomap aLoopbackMap[] =
    {
        { tstParseIPv4("127.0.0.1").s_addr, 42 }
    };
    const struct ip4_lomap_desc LoopbackMapDesc =
    {
        aLoopbackMap, RT_ELEMENTS(aLoopbackMap)
    };

    struct in_addr *paRealNameservers = tstDupInAddr("8.8.4.4");
    struct in6_addr *paIPv6RealNameservers = tstDupIn6Addr("2001:db8::53");
    RTTESTI_CHECK_RETV(paRealNameservers);
    RTTESTI_CHECK_RETV(paIPv6RealNameservers);

    SlirpConfig Cfg;
    RT_ZERO(Cfg);
    Cfg.version             = SLIRP_CONFIG_VERSION_MAX;
    Cfg.in_enabled          = true;
    Cfg.in6_enabled         = false;
    Cfg.vnetwork            = tstParseIPv4("10.0.2.0");
    Cfg.vnetmask            = tstParseIPv4("255.255.255.0");
    Cfg.vhost               = tstParseIPv4("10.0.2.2");
    Cfg.vdhcp_start         = tstParseIPv4("10.0.2.15");
    Cfg.vnameserver         = tstParseIPv4("10.0.2.3");
    Cfg.vprefix_len         = 64;
    Cfg.vhost6              = tstParseIPv6("fec0::2");
    Cfg.vnameserver6        = tstParseIPv6("fec0::3");
    Cfg.if_mtu              = 1500;
    Cfg.if_mru              = 1500;
    Cfg.if_mtu_v6           = 1280;
    Cfg.if_mru_v6           = 1280;
    Cfg.aRealNameservers    = paRealNameservers;
    Cfg.cRealNameservers    = 1;
    Cfg.aIPv6RealNameservers = paIPv6RealNameservers;
    Cfg.cIPv6RealNameservers = 1;
    Cfg.fForwardBroadcast   = true;
    Cfg.iSoMaxConn          = 7;
    Cfg.fDisableIPv6RA      = true;
    Cfg.mLoopbackMap        = &LoopbackMapDesc;

    SlirpCb Cb;
    RT_ZERO(Cb);
    Cb.send_packet  = tstSendPacket;
    Cb.guest_error  = tstGuestError;
    Cb.clock_get_ns = tstClockGetNs;
    Cb.timer_new    = tstTimerNew;
    Cb.timer_free   = tstTimerFree;
    Cb.timer_mod    = tstTimerMod;

    Slirp *pSlirp = slirp_new(&Cfg, &Cb, NULL);
    if (!pSlirp)
    {
        RTTestIFailed("slirp_new failed");
        RTMemFree(paRealNameservers);
        RTMemFree(paIPv6RealNameservers);
        return;
    }

    struct in_addr NetworkAddr = slirp_get_vnetwork_addr(pSlirp);
    RTTESTI_CHECK_MSG(NetworkAddr.s_addr == Cfg.vnetwork.s_addr,
                      ("NetworkAddr=%#RX32 expected %#RX32", NetworkAddr.s_addr, Cfg.vnetwork.s_addr));

    char *pszDomain = slirp_set_vdomainname(pSlirp, "vbox.example");
    RTTESTI_CHECK(pszDomain != NULL);
    RTTESTI_CHECK_MSG(strcmp(slirp_get_vdomainname(pSlirp), "vbox.example") == 0,
                      ("vdomainname='%s'", slirp_get_vdomainname(pSlirp)));

    static const char * const s_apszSearchDomains[] = { "vbox.example", "test.invalid", NULL };
    RTTESTI_CHECK(slirp_set_vdnssearch(pSlirp, s_apszSearchDomains) == 0);

    struct in_addr NameServer = tstParseIPv4("1.1.1.1");
    slirp_set_vnameserver(pSlirp, NameServer);

    struct in6_addr NameServer6 = tstParseIPv6("2001:4860:4860::8888");
    slirp_set_vnameserver6(pSlirp, NameServer6);
    slirp_set_disable_dns(pSlirp, true);
    slirp_set_disable_dns(pSlirp, false);

    struct in_addr *paNewRealNameservers = tstDupInAddr("9.9.9.9");
    struct in6_addr *paNewIPv6RealNameservers = tstDupIn6Addr("2001:db8::54");
    RTTESTI_CHECK(paNewRealNameservers != NULL);
    RTTESTI_CHECK(paNewIPv6RealNameservers != NULL);
    if (paNewRealNameservers && paNewIPv6RealNameservers)
    {
        slirp_set_RealNameservers(pSlirp, 1, paNewRealNameservers);
        slirp_set_IPv6RealNameservers(pSlirp, 1, paNewIPv6RealNameservers);
    }
    else
    {
        RTMemFree(paNewRealNameservers);
        RTMemFree(paNewIPv6RealNameservers);
    }

    RTTESTI_CHECK(slirp_version_string() != NULL);
    slirp_cleanup(pSlirp);
}


int main(int argc, char **argv)
{
    RT_NOREF(argc, argv);

    RTTEST hTest;
    int rc = RTTestInitAndCreate("tstNATLibslirpVBox", &hTest);
    if (rc)
        return rc;
    RTTestBanner(hTest);

    tstVBoxAbi();

    return RTTestSummaryAndDestroy(hTest);
}
