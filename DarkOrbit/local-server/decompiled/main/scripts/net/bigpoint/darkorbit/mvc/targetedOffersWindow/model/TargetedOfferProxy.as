package net.bigpoint.darkorbit.mvc.targetedOffersWindow.model
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class TargetedOfferProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "TargetedOffersProxy";
      
      private var _paymentLink:String;
      
      private var _packageName:String;
      
      public function TargetedOfferProxy(param1:String, param2:String, param3:Vector.<RewardModule>)
      {
         super(NAME,param3);
         this._packageName = param1;
         this._paymentLink = param2;
      }
      
      public function get paymentLink() : String
      {
         return this._paymentLink;
      }
      
      public function get packageName() : String
      {
         return this._packageName;
      }
      
      public function getItemRewards() : Array
      {
         var _loc2_:RewardModule = null;
         var _loc3_:ItemVO = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in data)
         {
            _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
            if(_loc3_ != null)
            {
               _loc3_.amount = _loc2_.amount;
               _loc1_.push(_loc3_);
            }
         }
         _loc1_.sort(ItemsDataUtility.itemSort.sortTargetedOffers);
         return _loc1_;
      }
   }
}

