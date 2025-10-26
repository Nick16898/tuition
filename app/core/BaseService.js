const { query, knex } = require("./Query");

/**
 * BaseModel
 * A flexible base model class for database interactions, combining Knex.js for query building
 * and Sequelize for query execution. This class provides generic CRUD operations and additional
 * features like counting records, while allowing custom Knex query logic to be injected.
 *
 * @param {string} table - The table name associated with the model.
 */
class BaseModel {
  constructor(table) {
    this.table = table;
  }

  /**
   * Executes a query using Knex and Sequelize.
   *
   * @param {Knex.QueryBuilder | function(Knex): Knex.QueryBuilder} knexQuery -
   *        Either a Knex query builder object or a callback function receiving Knex.
   * @returns {Promise<any>} The result of the query.
   * @throws {Error} If the query execution fails.
   * @example
   * // Using a Knex query builder instance ( this require knex import in file )
   * this.executeQuery(knex.from("user").where({ isActive: 1 }));
   *
   * @example
   * // Using a knex query builder callback ( this does not require knex import in file )
   * this.executeQuery(knex => knex.from("user").where({ isActive: 1 }));
   *
   * @example
   * // Using a callback function to modify the query dynamically
   * this.executeQuery(knex => {
   *   let query = knex.from("user").where({ isActive: 1 });
   *   if (filterName) {
   *     query = query.where("name", "ilike", filterName);
   *   }
   *   return query;
   * });
   */
  async executeQuery(knexQuery) {
    try {
      const knexQueryBuilder =
        typeof knexQuery === "function" ? knexQuery(knex) : knexQuery;
      const sql = knexQueryBuilder.toString();
      console.log('====================================');
      console.log(sql);
      console.log('====================================');
      return await query(sql);
    } catch (error) {
      console.error("Error executing query:", error);
      throw error;
    }
  }

  /**
   * Creates a new record in the database.
   *
   * @param {Object} data - The data to insert into the table.
   * @returns {Promise<Object>} The created record.
   * @throws {Error} If the creation fails.
   */
  async create(data) {
    try {
      const query = knex(this.table).insert(data).returning("*");
      const result = await this.executeQuery(query);
      return result[0]; // Return the created record
    } catch (error) {
      console.error("Error creating record:", error);
      throw error;
    }
  }

  /**
   * Creates multiple records in the database.
   *
   * @param {Array<Object>} dataArray - Array of objects to insert into the table.
   * @returns {Promise<Array<Object>>} The created records.
   * @throws {Error} If the bulk creation fails.
   */
  async bulkCreate(dataArray) {
    try {
      const query = knex(this.table).insert(dataArray).returning("*");
      const result = await this.executeQuery(query);
      return result; // Return all created records
    } catch (error) {
      console.error("Error bulk creating records:", error);
      throw error;
    }
  }

  /**
   * Updates a record in the database by ID.
   *
   * @param {number|string} id - The ID of the record to update.
   * @param {Object} data - The data to update.
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<Object|null>} The updated record, or null if not found.
   * @throws {Error} If the update fails.
   */
  async updateById(id, data, knexQueryBuilder) {
    try {
      let query = knex(this.table)
        .where(`${this.table}Id`, id)
        .update(data)
        .returning("*");

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result[0]; // Return the updated record
    } catch (error) {
      console.error("Error updating record:", error);
      throw error;
    }
  }

  /**
   * Updates a record in the database by given condition with callback.
   *
   * BE CAREFUL WHEN USING THIS METHOD, IF NOT PASSED PROPER CONDITION WILL UPDATE WHOLE TABLE
   *
   * @param {Object} data - The data to update.
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<Object|null>} The updated record, or null if not found.
   * @throws {Error} If the update fails.
   */
  async update(data, knexQueryBuilder) {
    try {
      let query = knex(this.table).update(data).returning("*");

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result[0]; // Return the updated record
    } catch (error) {
      console.error("Error updating record:", error);
      throw error;
    }
  }

  /**
   * Deletes a record from the database by ID.
   *
   * @param {number|string} id - The ID of the record to delete.
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<Object|null>} The deleted record, or null if not found.
   * @throws {Error} If the deletion fails.
   */
  async delete(id, knexQueryBuilder) {
    try {
      let query = knex(this.table)
        .where(`${this.table}Id`, id)
        .del()
        .returning("*");

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result[0]; // Return the deleted record
    } catch (error) {
      console.error("Error deleting record:", error);
      throw error;
    }
  }

  /**
   * Mark a record as deleted (soft delete).
   *
   * @param {number|string} id - The ID of the record to mark as deleted.
   * @param {Object} [updateFields] - Additional fields to update (e.g., updatedBy, updated timestamp).
   * @returns {Promise<Object|null>} The soft-deleted record, or null if not found.
   * @throws {Error} If the operation fails.
   */
  async softDelete(id, updateFields = {}) {
    const data = { delete: 1, ...updateFields };
    return this.update(id, data);
  }

  /**
   * Finds a single record by ID with optional additional query logic.
   *
   * @param {number|string} id - The ID of the record to find.
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<Object|null>} The found record, or null if not found.
   * @throws {Error} If the query fails.
   */
  async findById(id, knexQueryBuilder) {
    try {
      let query = knex(this.table).where(`${this.table}Id`, id);

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error("Error finding record by ID:", error);
      throw error;
    }
  }

  /**
   * Finds all records in the table with optional additional query logic.
   *
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<Array<Object>>} An array of found records.
   * @throws {Error} If the query fails.
   */
  async findAll(knexQueryBuilder) {
    try {
      let query = knex(this.table);

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result;
    } catch (error) {
      console.error("Error finding records:", error);
      throw error;
    }
  }

  /**
   * Counts the number of records in the table with optional filtering.
   *
   * @param {(queryBuilder: knex) => void} [knexQueryBuilder] - Optional Knex query builder function for additional query logic.
   * @returns {Promise<number>} The count of records.
   * @throws {Error} If the query fails.
   */
  async count(knexQueryBuilder) {
    try {
      let query = knex(this.table).count("* as count");

      if (knexQueryBuilder) {
        query = knexQueryBuilder(query); // Apply additional query logic
      }

      const result = await this.executeQuery(query);
      return result[0]?.count || 0; // Return the count
    } catch (error) {
      console.error("Error counting records:", error);
      throw error;
    }
  }

  /**
   * Saves the provided data by either updating an existing record or creating a new one.
   *
   * - If `id` is greater than 0, the method updates the existing record with the given `id`,
   *   setting `updatedBy` and `updated` fields before calling `updateById()`.
   * - If `id` is not present or is 0, the method creates a new record, setting `createdBy`
   *   before calling `create()`.
   *
   * @param {Object} data - The data to be saved, including `id`.
   * @returns {Promise<Object>} - The result of the update or create operation.
   */
  async save(data) {
    if (id > 0) {
      return await this.updateById(id, data);
    }
    return await this.create(data);
  }

  async list(data) {
    const result = await this.findAll((qb) => {
      qb.select(`${this.table}.*`).where(`${this.table}.delete`, 0);

      if (data.limit && data.limit != "-1") {
        qb.limit(data.limit).offset(data.offset);
      }

      if (data.sort) {
        qb.orderBy(data.sort, data.sortBy);
      }
      return qb;
    });

    const count = await this.count((qb) => {
      qb.where(`${this.table}.delete`, 0);

      return qb;
    });

    return {
      list: result,
      totalRecord: count,
    };
  }

  /**
   * @param {Object} data - Query options
   * @param {Object} data.condition - WHERE clause for base table
   * @param {Array} data.joinClue - Array of join instructions
   * @param {Array} data.column - Columns to select
   * @param {number} data.limit - Number of rows to return
   * @param {number} data.offset - Rows to skip
   * @param {Array} data.orderBy - [column, direction]
   * @param {string} data.searchTerm - Global search string
   * @param {Array} data.searchColumns - Columns for searchTerm
   * @param {number} data.isCount - 1 to return count, 0 to skip
   * @param {function} knexQueryBuilder - Optional function to modify query
   */
  async selectDataWithSearchAndJoin(data = {}, knexQueryBuilder) {
    const {
      condition = {},
      joinClue = [],
      column = [],
      limit = 0,
      offset = 0,
      orderBy = [],
      searchTerm = "",
      searchColumns = [],
      isCount = 1,
    } = data;

    // Base query
    let query = knex(this.table).select(column).where(condition).offset(offset);

    // Apply joins
    if (Array.isArray(joinClue) && joinClue.length > 0) {
      joinClue.forEach((join) => {
        query.leftJoin(join.tableName, function () {
          this.on(join.local, "=", join.forien);
          if (join.where && typeof join.where === "object") {
            Object.entries(join.where).forEach(([key, val]) => {
              if (val && typeof val.toSQL === "function") {
                // Support for knex.raw() or knex.max()
                this.andOn(knex.raw("?? = (?)", [key, val]));
              } else if (typeof val === "object" && val !== null) {
                const op = Object.keys(val)[0];
                this.andOn(knex.raw(`?? ${op} ?`, [key, val[op]]));
              } else {
                this.andOn(knex.raw(`?? = ?`, [key, val]));
              }
            });
          }
        });
      });
    }

    // Apply search
    if (
      searchTerm &&
      Array.isArray(searchColumns) &&
      searchColumns.length > 0
    ) {
      query.andWhere((builder) => {
        searchColumns.forEach((col) => {
          if (col.includes(".")) {
            const [table, column] = col.split(".");
            builder.orWhereRaw(`"${table}"."${column}"::text ILIKE ?`, [
              `%${searchTerm}%`,
            ]);
          } else {
            builder.orWhereRaw(`"${col}"::text ILIKE ?`, [`%${searchTerm}%`]);
          }
        });
      });
    }

    // Apply order
    if (Array.isArray(orderBy) && orderBy.length === 2) {
      const [orderByColumn, orderDirection] = orderBy;
      if (["ASC", "DESC"].includes(orderDirection.toUpperCase())) {
        query.orderBy(orderByColumn, orderDirection.toUpperCase());
      }
    }

    if (limit > 0) {
      query.limit(limit);
    }

    if (knexQueryBuilder) {
      query = knexQueryBuilder(query);
    }

    const result = await this.executeQuery(query);

    // Count
    let totalCount = 0;
    if (isCount === 1) {
      let countQuery = knex(this.table)
        .count("* as totalCount")
        .where(condition);

      if (Array.isArray(joinClue) && joinClue.length > 0) {
        joinClue.forEach((join) => {
          countQuery.leftJoin(join.tableName, function () {
            this.on(join.local, "=", join.forien);
            if (join.where && typeof join.where === "object") {
              Object.entries(join.where).forEach(([key, val]) => {
                if (val && typeof val.toSQL === "function") {
                  this.andOn(knex.raw("?? = (?)", [key, val]));
                } else if (typeof val === "object" && val !== null) {
                  const op = Object.keys(val)[0];
                  this.andOn(knex.raw(`?? ${op} ?`, [key, val[op]]));
                } else {
                  this.andOn(knex.raw(`?? = ?`, [key, val]));
                }
              });
            }
          });
        });
      }

      if (
        searchTerm &&
        Array.isArray(searchColumns) &&
        searchColumns.length > 0
      ) {
        countQuery.andWhere((builder) => {
          searchColumns.forEach((col) => {
            if (col.includes(".")) {
              const [table, column] = col.split(".");
              builder.orWhereRaw(`"${table}"."${column}"::text ILIKE ?`, [
                `%${searchTerm}%`,
              ]);
            } else {
              builder.orWhereRaw(`"${col}"::text ILIKE ?`, [`%${searchTerm}%`]);
            }
          });
        });
      }

      const countResult = await this.executeQuery(countQuery);
      totalCount = countResult[0]?.totalCount || 0;
    }

    return isCount === 1
      ? { count: totalCount, data: result }
      : { data: result };
  }

  /**
 * Calculate the end date based on a start date, duration, and type.
 *
 * @param {Object} data - Query options.
 * @param {string} data.date - Start date in 'YYYY-MM-DD' format.
 * @param {number} data.duration - Number of days, months, or years to add.
 * @param {string} data.type - Type of duration ('Day', 'Month', or 'Year').
 * @returns {string} End date in 'YYYY-MM-DD' format.
 *
 * @example
 * calculateEndDate({ date: "2025-10-26", duration: 2, type: "Month" });
 * // returns "2025-12-26"
 */
  async calculateEndDate(data) {
    const { date, duration, type } = data;
    const startDate = new Date(date);

    let endDate = new Date(startDate);

    switch (type.toLowerCase()) {
      case "day":
      case "days":
        endDate.setDate(startDate.getDate() + duration);
        break;

      case "monthly":
      case "months":
        endDate.setMonth(startDate.getMonth() + duration);
        break;

      case "annual":
      case "years":
        endDate.setFullYear(startDate.getFullYear() + duration);
        break;

      default:
        throw new Error("Invalid type! Use 'Day', 'Month', or 'Year'.");
    }

    // Format: YYYY-MM-DD
    return endDate.toISOString().split("T")[0];
  }


}

module.exports = BaseModel;
