const {
  DataTypes
} = require('sequelize');
module.exports = sequelize => {
  const attributes = {
    sessionId: {
      type: DataTypes.BIGINT,
      allowNull: false,
      comment: null,
      primaryKey: true,
      field: "sessionId",
      autoIncrement: true
    },
    type: {
      type: DataTypes.ENUM("ADMIN", "USER"),
      allowNull: true,
      defaultValue: "ADMIN",
      comment: null,
      field: "type",
    },
    userId: {
      type: DataTypes.BIGINT,
      allowNull: true,
      defaultValue: 0,
      comment: null,
      field: "userId",
    },
    token: {
      type: DataTypes.STRING(150),
      allowNull: true,
      defaultValue: null,
      comment: null,
      field: "token",
    },
    expireTime: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
      comment: null,
      field: "expireTime",
    },
    created: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
      comment: null,
      field: "created",
    },
    updated: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
      comment: null,
      field: "updated",
    },
  };
  const options = {
    tableName: "session",
    comment: "",
    indexes: []
  };
  const SessionModel = sequelize.define("session_model", attributes, options);
  return SessionModel;
};
