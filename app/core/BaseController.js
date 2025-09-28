/**
 * @fileoverview BaseController class that provides common controller methods (list and delete)
 * for interacting with the service layer. This class can be extended or instantiated
 * for different modules/entities.
 */

const fn = require("../helpers/string_helper");
require("../helpers/backup")

class BaseController {
  /**
   * Creates an instance of BaseController.
   *
   * p.s. if you want to keep default value for some param then pass then undefined or null.
   * @template T
   * @param {new () => T} service - The service class to instantiate.
   * @param {string} module - The name of the module/entity.
   * @param {string} [listSort="created"] - Default field for sorting list queries.
   * @param {string} [listSortBy="desc"] - Default sort order (e.g., "asc" or "desc").
   * @param {Object} [extraListParams={}] - Additional parameters to include in list queries.
   */
  constructor(service, module, listSort = "created", listSortBy = "desc", extraListParams = {}) {
    this.service = new service();
    this.module = module;
    this.listSort = listSort;
    this.listSortBy = listSortBy;
    this.extraListParams = extraListParams;
  }

  /**
   * Retrieves a paginated and sorted list of items.
   *
   * Extracts common query parameters from the request body and combines them with any extra
   * parameters defined in the controller. Calls the service layer to fetch the data.
   *
   * @async
   * @param {Object} req - Express request object.
   * @param {Object} res - Express response object.
   * @returns {Promise<Object>} - JSON response containing the status and data.
   */
  list = async (req, res) => {
    try {
      // Destructure pagination, search, sort, and additional parameters from request body
      const {
        offset = 0,
        limit = -1,
        term = "",
        sort = this.listSort,
        sortBy = this.listSortBy,
        ...requestParams
      } = req.body;

      // Retrieve adminId from request headers; default to 0 if not provided
      const adminId = req.headers.adminId || 0;
      // Data Encryption Level
      const elevel = 0;

      // Extract extra parameters from req.body, falling back to the defaults in extraListParams
      const extractedExtraListParams = Object.fromEntries(
        Object.entries(this.extraListParams).map(([key, defaultValue]) => [
          key,
          requestParams[key] !== undefined ? requestParams[key] : defaultValue
        ])
      );

      // Call the service to fetch the list with the assembled parameters
      const list = await this.service.list({
        offset,
        limit,
        term,
        sort,
        sortBy,
        adminId,
        ...extractedExtraListParams
      });

      // Return a success response if the list is successfully retrieved
      return fn.successResponse(res, `Successfully Fetched ${this.module} List`, elevel, list);
    } catch (error) {
      return fn.errorResponse(res, "Error fetching list", error);
    }
  }

  /**
   * Deletes an item identified by its id.
   *
   * Extracts the id from the request body and the adminId from the request headers.
   * Then calls the service layer to perform the deletion. If successful, returns a success
   * response; otherwise, returns an error response.
   *
   * @async
   * @param {Object} req - Express request object.
   * @param {Object} res - Express response object.
   * @returns {Promise<Object>} - JSON response indicating success or failure.
   */
  delete = async (req, res) => {
    const id = req.body.id || 0;
    const adminId = req.headers.adminId || 0;

    try {
      // Call the service to delete the item with the specified id and adminId
      const isDeleted = await this.service.softDelete(id, { deleteBy: adminId });

      if (isDeleted) {
        return fn.successResponse(res, `Successfully Deleted ${this.module}`);
      }
      return fn.errorResponse(res, `Server Error! Couldn't Delete ${this.module}`);
    } catch (error) {
      return fn.errorResponse(res, "Something Went Wrong", error);
    }
  }

  /**
 * Calculates the great-circle distance between two geographic coordinates.
 *
 * Uses the Haversine formula to compute the distance between two points
 * given their latitude and longitude. The result is returned in kilometers.
 *
 * @param {number} lat1 - Latitude of the first location.
 * @param {number} lon1 - Longitude of the first location.
 * @param {number} lat2 - Latitude of the second location.
 * @param {number} lon2 - Longitude of the second location.
 * @returns {number} - The distance between the two points in kilometers.
 */
  getDistance = (lat1, lon1, lat2, lon2) => {
    const R = 6371; // Radius of the Earth in kilometers
    const toRad = (degree) => (degree * Math.PI) / 180; // Convert degrees to radians

    const dLat = toRad(lat2 - lat1);
    const dLon = toRad(lon2 - lon1);

    // Haversine formula
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(toRad(lat1)) *
      Math.cos(toRad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c; // Returns distance in kilometers
  }

}
module.exports = BaseController;
