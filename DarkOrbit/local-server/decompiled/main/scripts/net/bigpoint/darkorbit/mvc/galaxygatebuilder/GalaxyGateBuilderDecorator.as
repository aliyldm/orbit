package net.bigpoint.darkorbit.mvc.galaxygatebuilder
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.GateSelectorView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.GateView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.IconsView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.KronosGateProgressionView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.LoadingAnimationView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.LogView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.MachineView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.MultiplierView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.ProbabilityView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.SimpleAppView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.StatsView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.DataTransferEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MachineEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MaterializeEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MultiplierEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows.HadesStoryWindowView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows.HelpWindowView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows.MessageWindowView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows.StreunerStoryWindowView;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class GalaxyGateBuilderDecorator
   {
      
      public static var STAGE_WIDTH:int;
      
      public static var STAGE_HEIGHT:int;
      
      public static const ORIGIN_PT_X:int = 20;
      
      public static const ORIGIN_PT_Y:int = 40;
      
      private var _guiManager:GuiManager;
      
      private var _window:SimpleWindow;
      
      private var _gateBuilderModel:GalaxyGateBuilderModel;
      
      public function GalaxyGateBuilderDecorator(param1:GuiManager, param2:SimpleWindow)
      {
         super();
         this._guiManager = param1;
         this._window = param2;
         STAGE_WIDTH = this._window.width;
         STAGE_HEIGHT = this._window.height;
         this.init();
      }
      
      private function handleTest(param1:Event) : void
      {
      }
      
      private function init() : void
      {
         var _loc1_:GalaxyGateBuilderProxy = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:SimpleAppView = null;
         var _loc5_:GateView = null;
         var _loc6_:IconsView = null;
         var _loc7_:StatsView = null;
         this._gateBuilderModel = new GalaxyGateBuilderModel();
         _loc1_ = new GalaxyGateBuilderProxy(GuiConstants.GG_BUILDER_WINDOW,this._gateBuilderModel);
         GameFacade.getInstance().registerProxy(_loc1_);
         _loc2_ = new SimpleContainer(this._guiManager,0);
         this._window.addContainer(_loc2_);
         this._window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximize);
         _loc3_ = new SimpleAppView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc3_);
         _loc3_.x = 0 + ORIGIN_PT_X;
         _loc3_.y = 0 + ORIGIN_PT_Y;
         var _loc4_:GateSelectorView = new GateSelectorView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc4_);
         _loc4_.x = 0 + ORIGIN_PT_X;
         _loc4_.y = 0 + ORIGIN_PT_Y;
         _loc5_ = new GateView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc5_);
         _loc5_.x = 180 + ORIGIN_PT_X;
         _loc5_.y = 0 + ORIGIN_PT_Y;
         _loc6_ = new IconsView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc6_);
         _loc6_.x = 464 + ORIGIN_PT_X;
         _loc6_.y = 0 + ORIGIN_PT_Y;
         _loc7_ = new StatsView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc7_);
         _loc7_.x = 524 + ORIGIN_PT_X;
         _loc7_.y = 0 + ORIGIN_PT_Y;
         var _loc8_:LogView = new LogView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc8_);
         _loc8_.x = 524 + ORIGIN_PT_X;
         _loc8_.y = 190 + ORIGIN_PT_Y;
         var _loc9_:MachineView = new MachineView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc9_);
         _loc9_.x = 524 + ORIGIN_PT_X;
         _loc9_.y = 119 + ORIGIN_PT_Y;
         var _loc10_:MultiplierView = new MultiplierView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc10_);
         _loc10_.x = 524 + ORIGIN_PT_X;
         _loc10_.y = 43 + ORIGIN_PT_Y;
         var _loc11_:KronosGateProgressionView = new KronosGateProgressionView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc11_);
         _loc11_.x = 525 + ORIGIN_PT_X;
         _loc11_.y = 42 + ORIGIN_PT_Y;
         var _loc12_:HadesStoryWindowView = new HadesStoryWindowView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc12_);
         _loc12_.x = 0 + ORIGIN_PT_X;
         _loc12_.y = 0 + ORIGIN_PT_Y;
         var _loc13_:StreunerStoryWindowView = new StreunerStoryWindowView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc13_);
         _loc13_.x = 0 + ORIGIN_PT_X;
         _loc13_.y = 0 + ORIGIN_PT_Y;
         var _loc14_:MessageWindowView = new MessageWindowView(this._gateBuilderModel,_loc1_);
         var _loc15_:ProbabilityView = new ProbabilityView(this._gateBuilderModel,_loc1_);
         _loc14_.probabilityView = _loc15_;
         _loc14_.add(_loc15_);
         _loc2_.addChild(_loc14_);
         _loc14_.x = 0 + ORIGIN_PT_X;
         _loc14_.y = 0 + ORIGIN_PT_Y;
         var _loc16_:HelpWindowView = new HelpWindowView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc16_);
         _loc16_.x = 0 + ORIGIN_PT_X;
         _loc16_.y = 0 + ORIGIN_PT_Y;
         var _loc17_:LoadingAnimationView = new LoadingAnimationView(this._gateBuilderModel,_loc1_);
         _loc2_.addChild(_loc17_);
         _loc17_.x = STAGE_WIDTH / 2;
         _loc17_.y = STAGE_HEIGHT / 2;
         this._gateBuilderModel.addEventListener(DataTransferEvent.PRELOAD_BACKGROUND_COMPLETE,_loc3_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc3_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.LANGUAGE_LOADED,_loc17_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.LOADING_ON,_loc17_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.LOADING_OFF,_loc17_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc15_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc7_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.HOLD,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.RUN,_loc14_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_SHOW_PROBABILITY,_loc14_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_LIFE_PURCHASE_INIT,_loc14_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_LIFE_PURCHASE_COMPLETE,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.URIDIUM_PURCHASE_INIT,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.URIDIUM_PURCHASE_COMPLETE,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ALPHA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_BETA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_GAMMA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_DELTA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_EPSILON,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ZETA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KAPPA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_LAMBDA,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KRONOS,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_HADES,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_STREUNER,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ALPHA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_BETA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_GAMMA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_DELTA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_EPSILON,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ZETA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KAPPA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_LAMBDA,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KRONOS,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_HADES,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_STREUNER,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ALPHA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_BETA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_GAMMA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_DELTA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_EPSILON,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ZETA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KAPPA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_LAMBDA,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KRONOS,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_HADES,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_STREUNER,_loc11_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_PROGRESS,_loc11_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ALPHA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_BETA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_GAMMA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_DELTA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_EPSILON,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ZETA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KAPPA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_LAMBDA,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_HADES,_loc8_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_STREUNER,_loc8_.update);
         this._gateBuilderModel.addEventListener(MachineEvent.ON_RESIZE,_loc8_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_NEW_OUTPUT,_loc14_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_DUPLICATE_PART,_loc14_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_MULTIPLE_PART_OUTPUT,_loc14_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_SHOW_MESSAGE,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STOP,_loc14_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_SETUP,_loc14_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.TRANSFER_COMPLETE,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.RUN,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.SPIN_AMOUNT_UPDATE,_loc9_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_NEW_OUTPUT,_loc9_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_NEW_OUTPUT,_loc8_.update);
         this._gateBuilderModel.addEventListener(MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.NUMBERS_UPDATE,_loc7_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.NUMBERS_UPDATE,_loc9_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.URIDIUM_UPDATE,_loc7_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.WAVES_UPDATE,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.LIFE_PRICE_UPDATE,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.LIVES_LEFT_UPDATE,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.BUY_BUTTON_VISIBILITY,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.JUMP_BUTTON_VISIBILITY,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc5_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_PROGRESS,_loc5_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_DETAILS,_loc5_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc10_.update);
         this._gateBuilderModel.addEventListener(MultiplierEvent.CHANGE,_loc10_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc4_.update);
         this._gateBuilderModel.addEventListener(GateEvent.GATE_DETAILS,_loc4_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ALPHA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_BETA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_GAMMA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_DELTA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_EPSILON,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_ZETA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KAPPA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_LAMBDA,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_KRONOS,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_HADES,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.STATE_STREUNER,_loc6_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.INIT_COMPLETE,_loc16_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.HELP_ON,_loc16_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.HELP_OFF,_loc16_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.HELP_COMPLETE,_loc16_.update);
         this._gateBuilderModel.addEventListener(ApplicationEvent.MATERIALIZE,_loc9_.activateBeam);
         this._gateBuilderModel.init(this);
      }
      
      private function onWindowMaximize(param1:SimpleWindowEvent) : void
      {
         this._gateBuilderModel.dispatchEvent(new MaterializeEvent(MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON));
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         if(_loc2_ == 70)
         {
            this.toggleStats();
         }
         else
         {
            this._gateBuilderModel.handleKeyDown(_loc2_);
         }
      }
      
      private function toggleStats() : void
      {
      }
   }
}

