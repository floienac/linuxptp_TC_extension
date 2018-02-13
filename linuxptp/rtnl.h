/**
 * @file rtnl.h
 * @brief Interface link status via RT netlink
 * @note Copyright (C) 2012 Richard Cochran <richardcochran@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
#ifndef HAVE_RTNL_H
#define HAVE_RTNL_H

#include "config.h"

typedef void (*rtnl_callback)(void *ctx, int linkup, int ts_index);

/**
 * Close a RT netlink socket.
 * @param fd  A socket obtained via rtnl_open().
 * @return    Zero on success, non-zero otherwise.
 */
int rtnl_close(int fd);

/**
 * Get interface ts_label information
 * @param iface  struct interface.
 * @return       Zero on success, or -1 on error.
 */
int rtnl_get_ts_label(struct interface *iface);

/**
 * Request the link status from the kernel.
 * @param fd     A socket obtained via rtnl_open().
 * @param device Interface name. Request all iface's status if set NULL.
 * @return       Zero on success, non-zero otherwise.
 */
int rtnl_link_query(int fd, char *device);

/**
 * Read kernel messages looking for a link up/down events.
 * @param fd     Readable socket obtained via rtnl_open().
 * @param device The device which we need to get link info.
 * @param cb     Callback function to be invoked on each event.
 * @param ctx    Private context passed to the callback.
 * @return       Zero on success, non-zero otherwise.
 */
int rtnl_link_status(int fd, char *device, rtnl_callback cb, void *ctx);

/**
 * Open a RT netlink socket for monitoring link state.
 * @return    A valid socket, or -1 on error.
 */
int rtnl_open(void);

#endif
