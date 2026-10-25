package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.purchaseLevels
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class SeasonPassUIPurchaseLevelsView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function SeasonPassUIPurchaseLevelsView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.labelUridium.text = ItemDataProviderHelper.getItem("currency_uridium").codeName;
      }
      
      public function get title() : String
      {
         return "seasonPass_popup_purchaseLevels";
      }
      
      public function get labelCurrLevel() : Label
      {
         return this._fuiCache.selectComponent("root.content.level.current.label") as Label;
      }
      
      public function get labelUpgradeLevel() : Label
      {
         return this._fuiCache.selectComponent("root.content.level.upgraded.value.label") as Label;
      }
      
      public function get btnMinus() : Button
      {
         return this._fuiCache.selectComponent("root.content.level.upgraded.value.minus") as Button;
      }
      
      public function get btnPlus() : Button
      {
         return this._fuiCache.selectComponent("root.content.level.upgraded.value.plus") as Button;
      }
      
      public function get btnMax() : Button
      {
         return this._fuiCache.selectComponent("root.content.level.upgraded.max") as Button;
      }
      
      public function get iconUridium() : Coreponent
      {
         return this._fuiCache.selectComponent("root.content.cost.uridium.icon") as Coreponent;
      }
      
      private function get labelUridium() : Label
      {
         return this._fuiCache.selectComponent("root.content.cost.uridium.uridium") as Label;
      }
      
      public function get labelCostPlayer() : Label
      {
         return this._fuiCache.selectComponent("root.content.cost.value.player") as Label;
      }
      
      public function get labelCostRequired() : Label
      {
         return this._fuiCache.selectComponent("root.content.cost.value.required") as Label;
      }
      
      public function get btnUpgrade() : Button
      {
         return this._fuiCache.selectComponent("root.content.bottom.btnUpgrade") as Button;
      }
      
      public function get btnCancel() : Button
      {
         return this._fuiCache.selectComponent("root.content.bottom.btnCancel") as Button;
      }
   }
}

