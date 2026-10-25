package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.mediator
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.IResultWindowMediator;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.model.StatsHeaderLableTweenVo;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.model.vo.TDMResultWindowModel;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.TDMMatchResultWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class TDMResultWindowMediator extends Mediator implements IResultWindowMediator
   {
      
      public static const NAME:String = "TDMResultWindowMediator";
      
      public function TDMResultWindowMediator(param1:TDMMatchResultWindow)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.CLOSE_WINDOW_BY_TYPE,TDMResultWindowNotifications.SET_DATA];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case GuiNotifications.CLOSE_WINDOW_BY_TYPE:
               if(param1.getBody() as String == FlexWindowManager.TEAMDEATHMATCH_RESULT_WINDOW)
               {
                  this.handleWindowClosed();
               }
               break;
            case TDMResultWindowNotifications.SET_DATA:
               this.view.windowData = param1.getBody() as TDMResultWindowModel;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.view.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleWindowClosed);
      }
      
      override public function onRemove() : void
      {
         if(this.view)
         {
            sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,this.view.windowType);
         }
         super.onRemove();
      }
      
      private function get view() : TDMMatchResultWindow
      {
         return viewComponent as TDMMatchResultWindow;
      }
      
      private function handleWindowClosed(param1:Event = null) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      public function set headerText(param1:String) : void
      {
         this.view.victoryLabel.headerText = param1;
      }
      
      public function setHeaderImage(param1:Bitmap) : void
      {
         this.view.setHeaderImage(param1);
      }
      
      public function setGradient(param1:Bitmap) : void
      {
         this.view.victoryLabel.gradient = param1;
      }
      
      public function set title(param1:String) : void
      {
         this.view.title = param1;
      }
      
      public function setEffectImg(param1:DisplayObject) : void
      {
         this.view.victoryLabel.effectImg = param1;
      }
      
      public function setTexture(param1:DisplayObject) : void
      {
         this.view.victoryLabel.texture = param1;
      }
      
      public function setBackground(param1:DisplayObject) : void
      {
         this.view.victoryLabel.backGround = param1;
      }
      
      public function updateWindowTweens(param1:StatsHeaderLableTweenVo) : void
      {
         this.view.victoryLabel.tweenVo = param1;
      }
   }
}

