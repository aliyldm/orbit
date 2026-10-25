package net.bigpoint.darkorbit.mvc.booster.model.boosterItems
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.darkorbit.com.module.BoosterBattleStationDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterModuleAttributes;
   
   public class BattleStationBoosterItem extends BoosterItem
   {
      
      private var _percentage:Number = 0;
      
      private var _categories:Vector.<String>;
      
      public function BattleStationBoosterItem()
      {
         super();
      }
      
      override public function update(param1:BoosterDetailModule) : void
      {
         var _loc2_:BoosterBattleStationDetailModule = param1 as BoosterBattleStationDetailModule;
         this._percentage = _loc2_.percentage;
         super.update(param1);
      }
      
      private function get attribute() : BoosterModuleAttributes
      {
         return _item.item.attributes as BoosterModuleAttributes;
      }
      
      override public function get categories() : Vector.<String>
      {
         return this._categories ? this._categories : (this._categories = new <String>[this.attribute.attribute]);
      }
      
      override public function getEffectText(param1:String) : String
      {
         return "";
      }
      
      override public function getValueText(param1:String) : String
      {
         return TextFormatter.round(this._percentage,2) + "%";
      }
      
      override public function getDescription(param1:String) : String
      {
         return _item.rawDescription;
      }
      
      override public function getPercentage(param1:String) : Number
      {
         return this._percentage;
      }
   }
}

