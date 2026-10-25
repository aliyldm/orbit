package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.DataTransferEvent;
   
   public class SimpleAppView extends CompositeView
   {
      
      private var _bgLoaded:Boolean;
      
      private var _initComplete:Boolean;
      
      private var _bg:DisplayObject;
      
      public function SimpleAppView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:AssetsProxy = null;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case DataTransferEvent.PRELOAD_BACKGROUND_COMPLETE:
               _loc3_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
               this._bg = _loc3_.getBitmap("common","main_bg");
               this._bg.alpha = 0;
               addChild(this._bg);
               this._bgLoaded = true;
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this._initComplete = true;
         }
         if(this._bgLoaded && this._initComplete)
         {
            TweenLite.to(this._bg,0.4,{"alpha":1});
         }
      }
   }
}

