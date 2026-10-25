package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.view
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class StrikeAndExitInfoView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _icons:Vector.<Coreponent> = new Vector.<Coreponent>();
      
      private var _Labels:Vector.<Label> = new Vector.<Label>();
      
      public function StrikeAndExitInfoView(param1:SimpleWindow)
      {
         super();
         var _loc2_:Sprite = param1.getUIContainer();
         this._cache = new FuiComponentSelectorCache(_loc2_);
         this.init();
      }
      
      public function get infoButton() : Button
      {
         return this._cache.selectComponent("root.main.infoBtn") as Button;
      }
      
      public function get endTime() : Label
      {
         return this._cache.selectComponent("root.main.top.item0.endTime") as Label;
      }
      
      public function get itemAIcon() : Coreponent
      {
         return this._icons[0];
      }
      
      public function get itemALabel() : Label
      {
         return this._Labels[0];
      }
      
      public function get boxersIcon() : Coreponent
      {
         return this._icons[1];
      }
      
      public function get boxersLabel() : Label
      {
         return this._Labels[1];
      }
      
      public function get NPC1Icon() : Coreponent
      {
         return this._icons[2];
      }
      
      public function get NPC1Label() : Label
      {
         return this._Labels[2];
      }
      
      public function get NPC2Icon() : Coreponent
      {
         return this._icons[3];
      }
      
      public function get NPC2Label() : Label
      {
         return this._Labels[3];
      }
      
      public function get NPC3Icon() : Coreponent
      {
         return this._icons[4];
      }
      
      public function get NPC3Label() : Label
      {
         return this._Labels[4];
      }
      
      public function get bossIcon() : Coreponent
      {
         return this._icons[5];
      }
      
      public function get bossLabel() : Label
      {
         return this._Labels[5];
      }
      
      public function get treasureIcon() : Coreponent
      {
         return this._icons[6];
      }
      
      public function get treasureLabel() : Label
      {
         return this._Labels[6];
      }
      
      public function get spawn() : Label
      {
         return this._Labels[7];
      }
      
      public function init() : void
      {
         var _loc1_:Coreponent = null;
         var _loc2_:Label = null;
         this._icons.length = 0;
         this._Labels.length = 0;
         _loc1_ = this._cache.selectComponent("root.main.top.item0.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.top.item0.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.body.item1.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.body.item1.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.body.item2.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.body.item2.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.body.item3.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.body.item3.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.body.item4.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.body.item4.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.bottom.item5.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.bottom.item5.label") as Label;
         this._Labels.push(_loc2_);
         _loc1_ = this._cache.selectComponent("root.main.bottom.item6.icon") as Coreponent;
         this._icons.push(_loc1_);
         _loc2_ = this._cache.selectComponent("root.main.bottom.item6.label") as Label;
         this._Labels.push(_loc2_);
         _loc2_ = this._cache.selectComponent("root.main.body.item1.spawn") as Label;
         this._Labels.push(_loc2_);
         this.itemALabel.text = "Item A";
         this.boxersLabel.text = "Boxers";
         this.NPC1Label.text = "NPC 1";
         this.NPC2Label.text = "NPC 2";
         this.NPC3Label.text = "NPC 3";
         this.bossLabel.text = "Boss";
         this.treasureLabel.text = "Treasure";
      }
      
      public function get mainContainer() : DisplayObjectContainer
      {
         return this._cache.selectComponent("root.main") as DisplayObjectContainer;
      }
      
      public function get tItem6() : DisplayObjectContainer
      {
         return this._cache.selectComponent("root.main.bottom.item6") as DisplayObjectContainer;
      }
   }
}

