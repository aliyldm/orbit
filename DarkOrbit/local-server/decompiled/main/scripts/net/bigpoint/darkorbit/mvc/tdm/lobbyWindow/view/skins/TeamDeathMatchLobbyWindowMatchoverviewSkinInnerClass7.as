package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.skins
{
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.primitives.Rect;
   
   public class TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass7 extends Rect
   {
      
      private var _88844982outerDocument:TeamDeathMatchLobbyWindowMatchoverviewSkin;
      
      public function TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass7()
      {
         super();
         this.fill = this._TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass7_SolidColor1_c();
      }
      
      private function _TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass7_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : TeamDeathMatchLobbyWindowMatchoverviewSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:TeamDeathMatchLobbyWindowMatchoverviewSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
   }
}

