/**
 * Created by joelwasserman on 8/29/16.
 */

module.exports = function (sequelize, DataTypes) {
  var Transaction = sequelize.define('Transaction', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    points_spent: {
      type: DataTypes.INTEGER,
      field: 'points_spent'
    },
    vendor: {
      type: DataTypes.STRING,
      field: 'vendor'
    },
    user_email: {
      type: DataTypes.STRING,
      field: 'user_email'
    },
  }, {
    classMethods: {

    },
    instanceMethods: {

    },
    indexes: [

    ]
  });

  return Transaction;
};