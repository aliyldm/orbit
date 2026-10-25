package net.bigpoint.darkorbit.mvc.gui.messages.view
{
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.components.GlobalNotificationView;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.components.InstantLogView;
   
   public class GlobalNotificationsMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "GlobalNotificationsMediator";
      
      public function GlobalNotificationsMediator()
      {
         super(NAME);
      }
      
      public function setUp() : void
      {
         var _loc1_:GlobalNotificationView = null;
         if(this.globalNotificationView == null)
         {
            _loc1_ = new GlobalNotificationView();
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
            viewComponent = _loc1_;
         }
         if(!screenManager.mainmenuLayer.contains(this.globalNotificationView))
         {
            this.globalNotificationView.x = this.globalNotificationView.itemWidth * -0.5;
            this.globalNotificationView.y = 0;
            this.instantLogView.addChild(this.globalNotificationView);
         }
      }
      
      public function get globalNotificationView() : GlobalNotificationView
      {
         return this.getViewComponent() as GlobalNotificationView;
      }
      
      private function get instantLogView() : InstantLogView
      {
         var _loc1_:MessagesMediator = retrieveMediator(MessagesMediator.NAME) as MessagesMediator;
         if(_loc1_)
         {
            return _loc1_.instantLogView;
         }
         return null;
      }
   }
}

