package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class ComponentView extends Sprite
   {
      
      protected var model:Object;
      
      protected var proxy:Object;
      
      public function ComponentView(param1:Object, param2:Object = null)
      {
         super();
         this.model = param1;
         this.proxy = param2;
      }
      
      public function add(param1:ComponentView) : void
      {
         throw new IllegalOperationError("add operation not supported");
      }
      
      public function remove(param1:ComponentView) : void
      {
         throw new IllegalOperationError("remove operation not supported");
      }
      
      public function getChild(param1:int) : ComponentView
      {
         throw new IllegalOperationError("getChild operation not supported");
      }
      
      public function update(param1:Event = null) : void
      {
      }
      
      public function getModel() : IGalaxyGateBuilderModel
      {
         return this.model as IGalaxyGateBuilderModel;
      }
      
      public function getProxy() : GalaxyGateBuilderProxy
      {
         return this.proxy as GalaxyGateBuilderProxy;
      }
      
      protected function parseMode(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case ApplicationEvent.STATE_EPSILON:
               _loc2_ = GalaxyGateBuilderModel.STATE_EPSILON;
               break;
            case ApplicationEvent.STATE_ZETA:
               _loc2_ = GalaxyGateBuilderModel.STATE_ZETA;
               break;
            case ApplicationEvent.STATE_ALPHA:
               _loc2_ = GalaxyGateBuilderModel.STATE_ALPHA;
               break;
            case ApplicationEvent.STATE_GAMMA:
               _loc2_ = GalaxyGateBuilderModel.STATE_GAMMA;
               break;
            case ApplicationEvent.STATE_BETA:
               _loc2_ = GalaxyGateBuilderModel.STATE_BETA;
               break;
            case ApplicationEvent.STATE_DELTA:
               _loc2_ = GalaxyGateBuilderModel.STATE_DELTA;
               break;
            case ApplicationEvent.STATE_KAPPA:
               _loc2_ = GalaxyGateBuilderModel.STATE_KAPPA;
               break;
            case ApplicationEvent.STATE_LAMBDA:
               _loc2_ = GalaxyGateBuilderModel.STATE_LAMBDA;
               break;
            case ApplicationEvent.STATE_KRONOS:
               _loc2_ = GalaxyGateBuilderModel.STATE_KRONOS;
               break;
            case ApplicationEvent.STATE_HADES:
               _loc2_ = GalaxyGateBuilderModel.STATE_HADES;
               break;
            case ApplicationEvent.STATE_STREUNER:
               _loc2_ = GalaxyGateBuilderModel.STATE_STREUNER;
         }
         return _loc2_;
      }
      
      protected function deactivate() : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      protected function activate() : void
      {
         this.mouseChildren = true;
         this.mouseEnabled = true;
      }
      
      protected function fadeOut() : void
      {
         this.deactivate();
         TweenLite.to(this,0.3,{"alpha":0});
      }
      
      protected function fadeIn() : void
      {
         this.activate();
         TweenLite.to(this,0.5,{"alpha":1});
      }
   }
}

