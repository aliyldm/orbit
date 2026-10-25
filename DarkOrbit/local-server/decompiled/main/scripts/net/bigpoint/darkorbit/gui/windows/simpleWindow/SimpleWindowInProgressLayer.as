package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   
   public class SimpleWindowInProgressLayer extends Container implements ISimpleWindowInProgressLayer
   {
      
      private static const TEMPLATE_NAME:String = "commonui.window.inProgressOverlay";
      
      private var _window:IWindow;
      
      private var _darkLayer:Sprite;
      
      private var _cogwheelIconBigContainer:Coreponent;
      
      private var _cogwheelIconBigContainerStartPos:PointLite;
      
      private var _cogwheelIconBigContainerEndPos:PointLite;
      
      private var _cogwheelIconBig:Sprite;
      
      private var _cogwheelIconSmallContainer:Coreponent;
      
      private var _cogwheelIconSmallContainerStartPos:PointLite;
      
      private var _cogwheelIconSmallContainerEndPos:PointLite;
      
      private var _cogwheelIconSmall:Sprite;
      
      public function SimpleWindowInProgressLayer(param1:IWindow)
      {
         super();
         this._window = param1;
      }
      
      protected function create() : void
      {
         UISystem.getInstance().buildByTemplate(TEMPLATE_NAME,this,XMLBasedUIBuilder.TYPE,true);
         this._darkLayer = this.getChildByName("darkLayer") as Sprite;
         this._cogwheelIconBigContainer = this.getChildByName("cogBigContainer") as Coreponent;
         this._cogwheelIconBigContainerStartPos = new PointLite(this._cogwheelIconBigContainer.x,this._cogwheelIconBigContainer.y);
         this._cogwheelIconBigContainerEndPos = new PointLite(this._cogwheelIconBigContainer.x - 30,this._cogwheelIconBigContainer.y);
         this._cogwheelIconBigContainer.x = this._cogwheelIconBigContainerEndPos.x;
         this._cogwheelIconBigContainer.y = this._cogwheelIconBigContainerEndPos.y;
         this._cogwheelIconBig = this._cogwheelIconBigContainer.getChildByName("cogBig") as Sprite;
         this._cogwheelIconSmallContainer = this.getChildByName("cogSmallContainer") as Coreponent;
         this._cogwheelIconSmallContainerStartPos = new PointLite(this._cogwheelIconSmallContainer.x,this._cogwheelIconSmallContainer.y);
         this._cogwheelIconSmallContainerEndPos = new PointLite(this._cogwheelIconSmallContainer.x + 30,this._cogwheelIconSmallContainer.y);
         this._cogwheelIconSmallContainer.x = this._cogwheelIconSmallContainerEndPos.x;
         this._cogwheelIconSmallContainer.y = this._cogwheelIconSmallContainerEndPos.y;
         this._cogwheelIconSmall = this._cogwheelIconSmallContainer.getChildByName("cogSmall") as Sprite;
      }
      
      public function show() : void
      {
         if(this.numChildren == 0)
         {
            this.create();
         }
         this._show();
      }
      
      public function hide() : void
      {
         this._hide();
      }
      
      private function _show() : void
      {
         var _loc1_:Sprite = this._window.getUIContainer();
         _loc1_.mouseChildren = false;
         _loc1_.filters = [new BlurFilter(2,2,BitmapFilterQuality.LOW)];
         this._cogwheelIconSmall.visible = true;
         this._cogwheelIconBig.visible = true;
         this._cogwheelIconSmall.removeEventListener(Event.ENTER_FRAME,this.handleCogEnterFrameEvent);
         this._cogwheelIconSmall.addEventListener(Event.ENTER_FRAME,this.handleCogEnterFrameEvent);
         TweenLite.to(this._darkLayer,0.2,{"alpha":1});
         TweenLite.to(this._cogwheelIconSmallContainer,0.4,{
            "alpha":1,
            "x":this._cogwheelIconSmallContainerStartPos.x,
            "y":this._cogwheelIconSmallContainerStartPos.y
         });
         TweenLite.to(this._cogwheelIconBigContainer,0.4,{
            "alpha":1,
            "x":this._cogwheelIconBigContainerStartPos.x,
            "y":this._cogwheelIconBigContainerStartPos.y
         });
      }
      
      private function _hide() : void
      {
         var _loc1_:Sprite = this._window.getUIContainer();
         _loc1_.mouseChildren = true;
         _loc1_.filters = [];
         TweenLite.to(this._darkLayer,0.2,{"alpha":0});
         TweenLite.to(this._cogwheelIconSmallContainer,0.3,{
            "alpha":0,
            "x":this._cogwheelIconSmallContainerEndPos.x,
            "y":this._cogwheelIconSmallContainerEndPos.y,
            "onComplete":this.removeCogEnterFrameEventListener
         });
         TweenLite.to(this._cogwheelIconBigContainer,0.3,{
            "alpha":0,
            "x":this._cogwheelIconBigContainerEndPos.x,
            "y":this._cogwheelIconBigContainerEndPos.y
         });
      }
      
      private function handleCogEnterFrameEvent(param1:Event) : void
      {
         this._cogwheelIconSmall.rotation += -1;
         this._cogwheelIconBig.rotation += 1;
      }
      
      private function removeCogEnterFrameEventListener() : void
      {
         this._cogwheelIconSmall.removeEventListener(Event.ENTER_FRAME,this.handleCogEnterFrameEvent);
      }
   }
}

