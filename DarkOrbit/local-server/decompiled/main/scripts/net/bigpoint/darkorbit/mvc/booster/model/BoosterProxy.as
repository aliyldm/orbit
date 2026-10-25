package net.bigpoint.darkorbit.mvc.booster.model
{
   import net.bigpoint.darkorbit.com.module.AttributeBoosterUpdateCommand;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterUpdateModule;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class BoosterProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "BoosterProxy";
      
      public function BoosterProxy()
      {
         super(NAME,new BoosterModel());
      }
      
      private function get boosterModel() : BoosterModel
      {
         return data as BoosterModel;
      }
      
      public function updateCategories(param1:AttributeBoosterUpdateCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc7_:BoosterDetailModule = null;
         var _loc8_:BoosterUpdateModule = null;
         var _loc4_:Vector.<BoosterDetailModule> = param1.boostedDetailsUpdate;
         _loc2_ = int(_loc4_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc7_ = _loc4_[_loc3_];
            this.boosterModel.updateItem(_loc7_);
            _loc3_++;
         }
         var _loc5_:Vector.<BoosterDetailModule> = param1.boostedDetailsRemove;
         _loc2_ = int(_loc5_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc7_ = _loc5_[_loc3_];
            this.boosterModel.removeItem(_loc7_);
            _loc3_++;
         }
         var _loc6_:Vector.<BoosterUpdateModule> = param1.boostedAttributes;
         _loc2_ = int(_loc6_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = _loc6_[_loc3_];
            this.boosterModel.updateCategory(_loc8_.attributeType,_loc8_.value);
            _loc3_++;
         }
      }
      
      public function cleanup() : void
      {
         this.boosterModel.cleanup();
      }
   }
}

