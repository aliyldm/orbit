package net.bigpoint.darkorbit.mvc.booster.model.boosterItems
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterSharedDetailModule;
   import net.bigpoint.darkorbit.items.item.attributes.Boost;
   import net.bigpoint.darkorbit.items.item.attributes.SalvageEffect;
   
   public class SharedBoosterItem extends BoosterItem
   {
      
      private var _numberOfBoosters:int;
      
      public function SharedBoosterItem()
      {
         super();
      }
      
      override public function update(param1:BoosterDetailModule) : void
      {
         var _loc2_:BoosterSharedDetailModule = param1 as BoosterSharedDetailModule;
         this._numberOfBoosters = _loc2_.numberOfBoosters;
         super.update(param1);
      }
      
      override public function getValueText(param1:String) : String
      {
         var _loc2_:Boost = getBoostByCategory(param1);
         if(_loc2_)
         {
            return _loc2_.areaFactor + "%";
         }
         var _loc3_:SalvageEffect = getSalvageByCategory(param1);
         if(_loc3_)
         {
            return BPLocale.getItemInCategory("items","booster_types_" + _loc3_.mode.toLowerCase() + "_name") + ": " + _loc3_.value + "%";
         }
         return "";
      }
      
      override public function getEffectText(param1:String) : String
      {
         return this._numberOfBoosters > 0 ? this._numberOfBoosters + "x" : "";
      }
   }
}

