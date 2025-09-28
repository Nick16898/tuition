const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  const attributes = {
    systemsettingId: {
      type: DataTypes.BIGINT,
      allowNull: false,
      primaryKey: true,
      autoIncrement: true,
      field: "systemsettingId"
    },
    key: {
      type: DataTypes.STRING(150),
      allowNull: true,
      defaultValue: null,
      field: "key"
    },
    value: {
      type: DataTypes.TEXT,
      allowNull: true,
      defaultValue: null,
      field: "value"
    },
    delete: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: 0,
      field: "delete"
    },
    created: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
      field: "created"
    },
    createdBy: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
      field: "createdBy"
    },
    updated: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
      field: "updated"
    },
    updatedBy: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
      field: "updatedBy"
    },
  };

  const options = {
    tableName: "systemsetting",
    comment: "",
    indexes: [
      {
        unique: true,
        fields: ['key']
      }
    ]
  };

  const SystemsettingModel = sequelize.define("systemsetting_model", attributes, options);
  return SystemsettingModel;
};
