package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.com.module.RzoneClosingMapStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneConfirmationStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneLeavingStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneOnRZoneStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneQueueingStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneRegistrationStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneUnavailibleStatusModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.BaseCrossServerState;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewClosingStateDecorator;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewConfitmationStateDecorator;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewLeavingStateDecorator;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewOnRZoneStateDecorator;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewQueueingStateDecorator;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components.RZoneViewStateDecorator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RZoneView
   {
      
      private var _viewComponent:DisplayObjectContainer;
      
      private var _viewLookup:Object = {};
      
      private var _stateDecoratorClasses:Object = {};
      
      private var _decorator:RZoneViewStateDecorator;
      
      private var _all:Vector.<Coreponent> = new Vector.<Coreponent>(0);
      
      public function RZoneView(param1:DisplayObjectContainer)
      {
         super();
         this._viewComponent = param1;
         this._stateDecoratorClasses[RzoneQueueingStatusModule.instance.getLibcomModuleId()] = RZoneViewQueueingStateDecorator;
         this._stateDecoratorClasses[RzoneConfirmationStatusModule.instance.getLibcomModuleId()] = RZoneViewConfitmationStateDecorator;
         this._stateDecoratorClasses[RzoneClosingMapStatusModule.instance.getLibcomModuleId()] = RZoneViewClosingStateDecorator;
         this._stateDecoratorClasses[RzoneOnRZoneStatusModule.instance.getLibcomModuleId()] = RZoneViewOnRZoneStateDecorator;
         this._stateDecoratorClasses[RzoneLeavingStatusModule.instance.getLibcomModuleId()] = RZoneViewLeavingStateDecorator;
         this.addToLookup(RzoneConfirmationStatusModule.instance.getLibcomModuleId(),"CONFIRMATION");
         this.addToLookup(RzoneOnRZoneStatusModule.instance.getLibcomModuleId(),"ON_R_ZONE");
         this.addToLookup(RzoneQueueingStatusModule.instance.getLibcomModuleId(),"QUEUEING");
         this.addToLookup(RzoneRegistrationStatusModule.instance.getLibcomModuleId(),"REGISTRATION");
         this.addToLookup(RzoneUnavailibleStatusModule.instance.getLibcomModuleId(),"REGISTRATION_UNAVAILABLE");
         this.addToLookup(RzoneClosingMapStatusModule.instance.getLibcomModuleId(),"CLOSING");
         this.addToLookup(RzoneLeavingStatusModule.instance.getLibcomModuleId(),"LEAVING");
         this.hideAll();
      }
      
      private function hideAll() : void
      {
         var _loc1_:int = int(this._all.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            MovieClipUtils.removeDisplayObject(this._all[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addToLookup(param1:int, param2:String) : void
      {
         var _loc3_:Coreponent = FuiComponentSelectorUtil.selectComponent("stateContainer." + param2,this._viewComponent) as Coreponent;
         this._viewLookup[param1] = _loc3_;
         this._all.push(_loc3_);
      }
      
      public function set currentState(param1:BaseCrossServerState) : void
      {
         this.hideAll();
         var _loc2_:int = param1.state.getLibcomModuleId();
         var _loc3_:Coreponent = this._viewLookup[_loc2_];
         if(_loc3_)
         {
            if(this._decorator)
            {
               this._decorator.dispose();
               this._decorator = null;
            }
            this.stateContainer.addChild(_loc3_);
            if(this._stateDecoratorClasses[_loc2_])
            {
               this._decorator = new this._stateDecoratorClasses[_loc2_](_loc3_,param1);
            }
            this.stateContainer.setSize(_loc3_.width,_loc3_.height);
            this.stateContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT]);
            this.windowContainer.forceRedraw();
         }
      }
      
      public function get ON_R_ZONELeaveButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("leave",this._viewLookup[RzoneOnRZoneStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get CLOSINGLeaveButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("leave",this._viewLookup[RzoneClosingMapStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get REGISTRATIONRegisterButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("register",this._viewLookup[RzoneRegistrationStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get CONFIRMATIONYesButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("buttonContainer.yes",this._viewLookup[RzoneConfirmationStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get CONFIRMATIONNoButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("buttonContainer.no",this._viewLookup[RzoneConfirmationStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get QUEUEINGCancelButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("cancel",this._viewLookup[RzoneQueueingStatusModule.instance.getLibcomModuleId()]) as Button;
      }
      
      public function get stateContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("stateContainer",this._viewComponent) as Container;
      }
      
      public function get windowContainer() : Container
      {
         return this._viewComponent as Container;
      }
   }
}

