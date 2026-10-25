package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model.ShipBoostEventVO;
   
   public class ShipBoostEventSlotAssigner extends DefaultItemDataAssigner
   {
      
      private var _slot:Label;
      
      private var _effect:Label;
      
      private var _bg:Coreponent;
      
      private var _verticalDivider_1:Coreponent;
      
      public function ShipBoostEventSlotAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._slot = FuiComponentSelectorUtil.selectComponent("slot",this) as Label;
         this._verticalDivider_1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._effect = FuiComponentSelectorUtil.selectComponent("effect_col.effect",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            super.data = param1;
            this.update();
         }
      }
      
      private function update() : void
      {
         var _loc2_:Sprite = null;
         var _loc1_:ShipBoostEventVO = data as ShipBoostEventVO;
         if(_loc1_)
         {
            this._slot.localizedText = "ship_boost_schedule_content_time_" + _loc1_.data.day;
            this._slot.text = this._slot.text.replace("%STARTTIME%",_loc1_.data.startTime).replace("%ENDTIME%",_loc1_.data.endTime);
            this.ProcessTextKeyForEffect(_loc1_);
            if(_loc1_.isActive)
            {
               this._bg.registeredSkinName = "ship_boost_event_active_layer";
            }
            else if(_loc1_.isUpcoming)
            {
               this._bg.registeredSkinName = "ship_boost_event_upcoming_layer";
            }
            else
            {
               this._bg.registeredSkinName = "commonui_darklayer";
            }
            if(this._verticalDivider_1 != null && this._verticalDivider_1.numChildren == 0)
            {
               _loc2_ = new Sprite();
               _loc2_.graphics.lineStyle(1,3631231);
               _loc2_.graphics.lineTo(0,this._verticalDivider_1.height);
               this._verticalDivider_1.addChild(_loc2_);
            }
         }
      }
      
      private function GetBoosterAttributeTextKey(param1:String) : String
      {
         return "ship_boost_effects_modifiertype_" + param1.toLowerCase();
      }
      
      private function ProcessTextKeyForEffect(param1:ShipBoostEventVO) : void
      {
         var _loc6_:Number = NaN;
         this._effect.localizedText = "ship_boost_schedule_content_effects_generic";
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.data.attributeBoosts.length)
         {
            _loc6_ = param1.data.attributeBoosts[_loc5_].boostValue;
            if(_loc6_ >= 0)
            {
               if(param1.data.attributeBoosts[_loc5_].attribute.toUpperCase() == "ABILITY_COOLDOWN_TIME")
               {
                  _loc4_ += " -";
               }
               else
               {
                  _loc4_ += "+";
               }
            }
            _loc4_ += _loc6_;
            _loc4_ = _loc4_ + "% ";
            _loc4_ = _loc4_ + UISystem.localize(this.GetBoosterAttributeTextKey(param1.data.attributeBoosts[_loc5_].attribute));
            if(_loc5_ < param1.data.attributeBoosts.length - 1)
            {
               _loc4_ += ", ";
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < param1.data.eventNameTextKeys.length)
         {
            _loc3_ += UISystem.localize(param1.data.eventNameTextKeys[_loc5_]);
            if(_loc5_ < param1.data.eventNameTextKeys.length - 1)
            {
               _loc3_ += ", ";
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < param1.data.shipTypes.length)
         {
            _loc2_ += param1.data.shipTypes[_loc5_];
            if(_loc5_ < param1.data.shipTypes.length - 1)
            {
               _loc2_ += ", ";
            }
            _loc5_++;
         }
         this._effect.text = this._effect.text.replace("%BOOSTS%",_loc4_);
         this._effect.text = this._effect.text.replace("%EVENTS%",_loc3_);
         this._effect.text = this._effect.text.replace("%SHIPS%",_loc2_);
      }
   }
}

