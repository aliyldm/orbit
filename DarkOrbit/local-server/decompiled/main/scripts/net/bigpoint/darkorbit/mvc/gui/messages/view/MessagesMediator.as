package net.bigpoint.darkorbit.mvc.gui.messages.view
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.components.InstantLogView;
   
   public class MessagesMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "MessagesMediator";
      
      public function MessagesMediator(param1:InstantLogView)
      {
         super(NAME,param1);
      }
      
      public function setUp() : void
      {
         if(screenManager.mainmenuLayer)
         {
            this.instantLogView.mouseChildren = false;
            this.instantLogView.mouseEnabled = false;
            screenManager.mainmenuLayer.addChild(this.instantLogView);
         }
      }
      
      public function get instantLogView() : InstantLogView
      {
         return this.getViewComponent() as InstantLogView;
      }
      
      public function addMessage() : void
      {
         if(!this.instantLogView)
         {
         }
      }
      
      public function removeMessage(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.instantLogView)
         {
            _loc2_ = this.instantLogView.getChildByName(param1);
            if(_loc2_)
            {
               this.instantLogView.removeChild(_loc2_);
            }
         }
      }
   }
}

