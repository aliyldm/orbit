package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view
{
   import com.bealearts.collection.VectorCollection;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.ArenaMatchEndRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.IResultWindowMediator;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.model.StatsHeaderLableTweenVo;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class JackpotArenaMatchResultUiMEdiator extends Mediator implements IResultWindowMediator
   {
      
      public static const NAME:String = "JackpotArenaMatchResultUiMEdiator";
      
      public function JackpotArenaMatchResultUiMEdiator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.CLOSE_ALL_FLEX_WINDOWS];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case GuiNotifications.CLOSE_ALL_FLEX_WINDOWS:
               this.handleWindowClosed();
               break;
            case GuiNotifications.CLOSE_WINDOW_BY_TYPE:
               if(param1.getBody() as String == FlexWindowManager.JACKPOT_MATCH_RRESULT_WINDOW)
               {
                  this.handleWindowClosed();
               }
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.view.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleWindowClosed);
      }
      
      override public function onRemove() : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ArenaMatchEndRequest());
         super.onRemove();
      }
      
      private function get view() : JackpotArenaMatchResultWindow
      {
         return viewComponent as JackpotArenaMatchResultWindow;
      }
      
      private function handleWindowClosed(param1:Event = null) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      public function set title(param1:String) : void
      {
         this.view.title = param1;
      }
      
      public function set headerText(param1:String) : void
      {
         this.view.victoryLabel.headerText = param1;
      }
      
      public function set hint(param1:String) : void
      {
         this.view.hint = param1;
      }
      
      public function set heroHeadlineText(param1:String) : void
      {
         this.view.itemList.heroHeadline = param1;
      }
      
      public function set opponentHeadlineText(param1:String) : void
      {
         this.view.itemList.opponentHeadline = param1;
      }
      
      public function set statsHeadlineText(param1:String) : void
      {
         this.view.itemList.statsHeadline = param1;
      }
      
      public function set dataProvider(param1:VectorCollection) : void
      {
         this.view.itemList.dataProvider = param1;
      }
      
      public function setHeaderImage(param1:Bitmap) : void
      {
         this.view.setHeaderImage(param1);
      }
      
      public function setGradient(param1:Bitmap) : void
      {
         this.view.victoryLabel.gradient = param1;
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

