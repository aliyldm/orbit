package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.components.tooltip.ITooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.manager.TipUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ArmoryUnlockUIView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _helpBtn:StatesButtonDecorator;
      
      protected var _showTooltipIntervalID:uint = 0;
      
      private var _currentTooltipContainer:Container;
      
      protected var _tooltipDataAssigner:ITooltipDataAssigner = new DefaultTooltipDataAssigner();
      
      protected var _tooltipData:Object;
      
      public function ArmoryUnlockUIView(param1:SimpleWindow)
      {
         super();
         var _loc2_:SimpleWindow = param1;
         var _loc3_:Sprite = _loc2_.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(_loc3_);
         if(param1.helpBtn)
         {
            param1.removeHelpBtnClick();
            this._helpBtn = param1.helpBtn;
            this._helpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            this._helpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         }
      }
      
      protected function mouseOver(param1:MouseEvent) : void
      {
         this._showTooltipIntervalID = setTimeout(this.showTooltip,300);
      }
      
      protected function mouseOut(param1:MouseEvent) : void
      {
         TipUtil.removeCurrentTooltipContainer(this._currentTooltipContainer);
         clearTimeout(this._showTooltipIntervalID);
      }
      
      protected function showTooltip() : void
      {
         if(this.helpBtn)
         {
            if(!this._tooltipData)
            {
               this._tooltipData = BPLocale.getItem("armoryunlock_info");
            }
            if(!this._currentTooltipContainer)
            {
               this._currentTooltipContainer = TipUtil.createTip("ARMORY_UNLOCK_TIP");
            }
            TipUtil.showTip(this.helpBtn,this._currentTooltipContainer,this._tooltipDataAssigner,this._tooltipData);
         }
      }
      
      public function get helpBtn() : StatesButtonDecorator
      {
         return this._helpBtn;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get testButtonLef() : Button
      {
         return this._fuiCache.selectComponent("root.body.test_button_lef") as Button;
      }
      
      public function get testButtonRight() : Button
      {
         return this._fuiCache.selectComponent("root.body.test_button_right") as Button;
      }
      
      public function get ex01Btn() : Button
      {
         return this._fuiCache.selectComponent("root.body.explore01_btn") as Button;
      }
      
      public function get ex10Btn() : Button
      {
         return this._fuiCache.selectComponent("root.body.explore10_btn") as Button;
      }
      
      public function get cardsContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.cardsContainer") as Coreponent;
      }
      
      public function get timeLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.time_label") as Label;
      }
   }
}

