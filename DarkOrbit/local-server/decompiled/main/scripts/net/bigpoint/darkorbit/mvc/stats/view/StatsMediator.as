package net.bigpoint.darkorbit.mvc.stats.view
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.mvc.stats.StatsNotifications;
   import net.bigpoint.darkorbit.mvc.stats.model.vo.StatsVO;
   import net.bigpoint.darkorbit.mvc.stats.view.components.StatsView;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class StatsMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "StatsMediator";
      
      private var statsView:StatsView;
      
      public function StatsMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         this.statsView = new StatsView();
         this.statsView.init();
         this.view.addChild(this.statsView);
         this.statsView.hide();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [StatsNotifications.UPDATE,StatsNotifications.TOGGLE_VISIBILITY];
      }
      
      override public function getViewComponent() : Object
      {
         return this.statsView;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc5_:StatsVO = null;
         var _loc3_:String = param1.getName();
         var _loc4_:Object = param1.getBody();
         switch(_loc3_)
         {
            case StatsNotifications.UPDATE:
               _loc2_ = _loc4_ as Array;
               _loc5_ = _loc2_[0] as StatsVO;
               this.statsView.update(_loc5_);
               break;
            case StatsNotifications.TOGGLE_VISIBILITY:
               if(this.statsView.visible == false)
               {
                  this.statsView.show();
               }
               else
               {
                  this.statsView.hide();
               }
         }
      }
      
      private function get view() : DisplayObjectContainer
      {
         return viewComponent as DisplayObjectContainer;
      }
   }
}

