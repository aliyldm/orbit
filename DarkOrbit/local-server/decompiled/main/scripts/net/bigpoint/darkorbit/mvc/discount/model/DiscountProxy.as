package net.bigpoint.darkorbit.mvc.discount.model
{
   import net.bigpoint.darkorbit.com.module.UserInventoryModule;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class DiscountProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "DiscountProxy";
      
      public function DiscountProxy()
      {
         super(NAME,new DiscountRepository());
      }
      
      public function get discountRepository() : DiscountRepository
      {
         return data as DiscountRepository;
      }
      
      public function getAmountWithDiscount(param1:String, param2:Number, param3:String = null) : Number
      {
         return this.discountRepository.getAmountWithDiscount(param1,param2,param3);
      }
      
      public function updateFromServer(param1:UserInventoryModule) : void
      {
         this.discountRepository.setDiscountPercentage(DiscountID.activePremiumDiscount,param1.activePremiumDiscount);
         this.discountRepository.setDiscountPercentage(DiscountID.activeRebateSubDiscount,param1.activeRebateSubDiscount);
         this.discountRepository.setDiscountPercentage(DiscountID.activeHappyUpgradeDiscount,param1.activeHappyUpgradeDiscount);
         this.discountRepository.discountChanged.dispatch();
      }
   }
}

