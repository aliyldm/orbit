package net.bigpoint.darkorbit.mvc.discount.model
{
   public class DiscountModelFactory
   {
      
      private static const _buildMethod:Object = {};
      
      _buildMethod[DiscountID.activeRebateSubDiscount] = buildRebateSubDiscount;
      _buildMethod[DiscountID.activeHappyUpgradeDiscount] = buildHappyUpgradeDiscount;
      _buildMethod[DiscountID.activePremiumDiscount] = buildPremiumDiscount;
      
      public function DiscountModelFactory()
      {
         super();
      }
      
      public static function build(param1:String) : DiscountModel
      {
         return _buildMethod[param1]();
      }
      
      private static function buildRebateSubDiscount() : DiscountModel
      {
         return new DiscountModel(DiscountID.activeRebateSubDiscount,new <String>["currency_uridium"]);
      }
      
      private static function buildPremiumDiscount() : DiscountModel
      {
         return new DiscountModel(DiscountID.activePremiumDiscount,new <String>["currency_uridium"]);
      }
      
      private static function buildHappyUpgradeDiscount() : DiscountModel
      {
         var _loc1_:DiscountModel = new DiscountModel(DiscountID.activeHappyUpgradeDiscount,new <String>["currency_uridium"]);
         _loc1_.source = DiscountSource.UPGRADE;
         return _loc1_;
      }
   }
}

