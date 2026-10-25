package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.container.InfoContainer;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.LifeCounterComponent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ScoreFestWindowDecorator
   {
      
      private var guiManager:GuiManager;
      
      private var comboTimerBarYellow:uint = 15793557;
      
      private var comboBarGrey:uint = 16777215;
      
      private var comboBarRed:uint = 12255232;
      
      public function ScoreFestWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         this.prepareWindow(param1);
      }
      
      private function prepareWindow(param1:SimpleWindow) : void
      {
         var _loc3_:LifeCounterComponent = null;
         var _loc2_:InfoContainer = param1.getContainer(SimpleContainer.CLASS_SCORE_FEST_LIVES) as InfoContainer;
         _loc3_ = new LifeCounterComponent();
         _loc3_.maxDisplayWidth = param1.width;
         _loc3_.setRemainingLives(5,5);
         _loc2_.component = _loc3_;
         _loc3_.x = 30;
         _loc3_.y = 7;
         var _loc4_:InfoContainer = param1.getContainer(SimpleContainer.CLASS_SCORE_FEST_COMBO) as InfoContainer;
         var _loc5_:BarComponent = new BarComponent(this.comboBarGrey);
         TooltipControl.getInstance().addToolTip(_loc5_,BPLocale.getItem("ttip_scoreevent_combo"));
         _loc5_.removeBarClickability();
         _loc4_.component = _loc5_;
         _loc5_.setSecondaryColor(this.comboBarRed);
         _loc5_.x = 30;
         _loc5_.y = 8;
         _loc5_.setSize(150,15);
         _loc5_.setBarValueOnTop();
         var _loc6_:InfoContainer = param1.getContainer(SimpleContainer.CLASS_SCORE_FEST_COMBO_TIMER) as InfoContainer;
         var _loc7_:BarComponent = new BarComponent(this.comboTimerBarYellow);
         TooltipControl.getInstance().addToolTip(_loc7_,BPLocale.getItem("ttip_scoreevent_combotimer"));
         _loc7_.removeBarClickability();
         _loc6_.component = _loc7_;
         _loc7_.x = 30;
         _loc7_.y = 8;
         _loc7_.setSize(150,6);
      }
   }
}

