package net.bigpoint.darkorbit.mvc.abstract.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class DOAbstractMediator extends Mediator
   {
      
      private var _notificationsToMethodMaps:Dictionary = new Dictionary();
      
      public function DOAbstractMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         this.mapNotificationsToMethods();
      }
      
      protected function mapNotificationsToMethods() : void
      {
      }
      
      protected function mapNotificationToMethod(param1:String, param2:Function) : void
      {
         this._notificationsToMethodMaps[param1] = param2;
      }
      
      protected function unmapNotificationToMethod(param1:String) : void
      {
         if(this._notificationsToMethodMaps[param1] != null)
         {
            this._notificationsToMethodMaps[param1] = null;
            delete this._notificationsToMethodMaps[param1];
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in this._notificationsToMethodMaps)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         var _loc3_:Function = this._notificationsToMethodMaps[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_(param1);
         }
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return facade.retrieveMediator(param1);
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return facade.retrieveProxy(param1);
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         facade.registerMediator(param1);
      }
      
      public function setComponentVisibility(param1:Boolean, param2:DisplayObject, param3:Number = 0.3) : void
      {
         if(param2)
         {
            TweenLite.killTweensOf(param2);
            TweenLite.to(param2,param3,{"autoAlpha":int(param1)});
         }
      }
      
      protected function get guiProxy() : GuiProxy
      {
         return this.retrieveProxy(GuiProxy.NAME) as GuiProxy;
      }
      
      protected function get connectionProxy() : ConnectionProxy
      {
         return this.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
      }
      
      protected function get assetsProxy() : AssetsProxy
      {
         return this.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      
      protected function getFinisher(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1);
      }
      
      protected function get tooltipControl() : TooltipControl
      {
         return TooltipControl.getInstance();
      }
      
      protected function get screenManager() : ScreenManager
      {
         return ScreenManager.getInstance();
      }
      
      protected function get guiManager() : GuiManager
      {
         return GuiManager.instance;
      }
   }
}

