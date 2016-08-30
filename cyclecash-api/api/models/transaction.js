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
    meta: {
      type: DataTypes.JSON,
      field: 'meta'
    }
  }, {
    classMethods: {
      associate: function (models) {
        Transaction.hasOne(models.User, { foreignKey: 'user_id' });
      }
    },
    instanceMethods: {

    },
    indexes: [
      {
        unique: true,
        fields: ['email']
      }
    ]
  });

  return Transaction;
};