package net.bigpoint.darkorbit.mvc.gui.windows.common.mediator
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.UIBuilder;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class SimpleWindowMediator extends DOAbstractMediator
   {
      
      protected var _uiReady:Boolean = false;
      
      public function SimpleWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.closeWindow();
      }
      
      public function build() : void
      {
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.build();
      }
      
      public function loadAndBuildContent(param1:String) : void
      {
         this.simpleWindow.showInProgressOverlay();
         this.simpleWindow.loadAndBuildUI(param1,this.handleLoadAndBuildContentCallback);
      }
      
      public function clearResource(param1:String) : void
      {
         ResourceManager.fileCollection.clearResource(param1);
      }
      
      protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this.simpleWindow.hideInProgressOverlay();
         this._uiReady = true;
      }
      
      protected function closeWindow() : void
      {
         guiManager.closeWindow(this.simpleWindow);
      }
      
      protected function deleteWindow() : void
      {
         guiManager.deleteWindow(this.simpleWindow.id);
      }
      
      public function get window() : IWindow
      {
         return this.viewComponent as IWindow;
      }
      
      public function get UIContentContainer() : Sprite
      {
         return this.simpleWindow.getUIContainer();
      }
      
      public function get simpleWindow() : SimpleWindow
      {
         return this.viewComponent as SimpleWindow;
      }
      
      public function get UIFinisher() : SWFFinisher
      {
         return SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
      }
      
      public function isUIReady() : Boolean
      {
         return this._uiReady;
      }
      
      protected function get xmlUIBuilder() : XMLBasedUIBuilder
      {
         var _loc1_:UIBuilder = UISystem.getInstance().builder as UIBuilder;
         return _loc1_.builders[XMLBasedUIBuilder.TYPE] as XMLBasedUIBuilder;
      }
      
      protected function retrieveWindowProxy() : SimpleWindowProxy
      {
         return retrieveProxy(getMediatorName()) as SimpleWindowProxy;
      }
      
      protected function clear(... rest) : void
      {
         var _loc2_:* = undefined;
         if(rest == null || rest.length == 0)
         {
            this.clearResource(this.getMediatorName());
            GameFacade.getInstance().removeMediator(this.getMediatorName());
         }
         else
         {
            for(_loc2_ in rest)
            {
               this.clearResource(rest[_loc2_]);
               GameFacade.getInstance().removeMediator(rest[_loc2_]);
            }
         }
      }
   }
}

