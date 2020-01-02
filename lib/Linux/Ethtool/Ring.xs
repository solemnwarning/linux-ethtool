#include <stdlib.h>
#include <net/if.h>
#include <linux/ethtool.h>
#include <linux/sockios.h>
#include <string.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "ethtool.h"

MODULE = Linux::Ethtool::Ring		PACKAGE = Linux::Ethtool::Ring

int
_ethtool_gring(href, dev)
	SV *href
	const char *dev

	CODE:
		if(!(SvROK(href) && SvTYPE(SvRV(href)) == SVt_PVHV))
		{
			croak("First argument must be a hashref");
		}
		else if(strlen(dev) >= IFNAMSIZ)
		{
			errno  = ENAMETOOLONG;
			RETVAL = 0;
		}
		else{
			HV *hash = (HV*)(SvRV(href));

			struct ethtool_ringparam ring;
			ring.cmd = ETHTOOL_GRINGPARAM;

			if(_do_ioctl(dev, &ring))
			{
				hv_store(hash, "rx_max", 6,    newSVuv(ring.rx_max_pending), 0);
				hv_store(hash, "mini_max", 8,  newSVuv(ring.rx_mini_max_pending), 0);
				hv_store(hash, "jumbo_max", 9, newSVuv(ring.rx_jumbo_max_pending), 0);
				hv_store(hash, "tx_max", 6,    newSVuv(ring.tx_max_pending), 0);
				hv_store(hash, "rx", 2,        newSVuv(ring.rx_pending), 0);
				hv_store(hash, "mini", 4,      newSVuv(ring.rx_mini_pending), 0);
				hv_store(hash, "jumbo", 5,     newSVuv(ring.rx_jumbo_pending), 0);
				hv_store(hash, "tx", 2,        newSVuv(ring.tx_pending), 0);
				RETVAL = 1;
			}
			else{
				RETVAL = 0;
			}
		}
	OUTPUT:
		RETVAL

int
_ethtool_sring(dev, rx_max, mini_max, jumbo_max, tx_max, rx, mini, jumbo, tx)
	const char *dev
	unsigned int rx_max
	unsigned int mini_max
	unsigned int jumbo_max
	unsigned int tx_max
	unsigned int rx
	unsigned int mini
	unsigned int jumbo
	unsigned int tx

	CODE:
		if(strlen(dev) >= IFNAMSIZ)
		{
			errno  = ENAMETOOLONG;
			RETVAL = 0;
		}
		else{
			struct ethtool_ringparam ring;
			ring.cmd = ETHTOOL_SRINGPARAM;
			ring.rx_max_pending = rx_max;
			ring.rx_mini_max_pending = mini_max;
			ring.rx_jumbo_max_pending = jumbo_max;
			ring.tx_max_pending = tx_max;
			ring.rx_pending = rx;
			ring.rx_mini_pending = mini;
			ring.rx_jumbo_pending = jumbo;
			ring.tx_pending = tx;

			if(_do_ioctl(dev, &ring))
			{
				RETVAL = 1;
			}
			else{
				RETVAL = 0;
			}
		}
	OUTPUT:
		RETVAL
