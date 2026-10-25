package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBatteryItemModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBuyLifeCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBuyLifeRequest;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateCompleteCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateLifeLostCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateWaveUpdateCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGetGatePartsCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGetGatePartsRequest;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderInfoCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderInfoRequest;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderItemModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderLootItemModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderMultiEnergyCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderMultiEnergyRequest;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderMultiplierItemModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderPartItemModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderProbabilityModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderSaveSpinAmountRequest;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderSetupGateCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderSetupGateRequest;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.AmmoOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateBonusGGRewardVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.OutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.PartOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.ProbabilityVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.SpecialOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.utils.GateImageLoader;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.utils.ItemImageLoader;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.DataTransferEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MaterializeEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MultiplierEvent;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class GalaxyGateBuilderModel extends EventDispatcher implements IGalaxyGateBuilderModel
   {
      
      public static var MAX_GATES_COUNT:int = 0;
      
      public static var MODE_GATES:Array = [];
      
      public static const INIT_ASSET_PROXY:int = 1;
      
      public static const INIT_ITEM_LIB_SIMPLE_APP:int = 2;
      
      public static const INIT_ITEM_TRANSLATION:int = 4;
      
      public static const INIT_ITEM_LIB_MAIN:int = 8;
      
      public static const INIT_ITEM_LIB_GATES:int = 16;
      
      public static const INIT_ITEM_CONFIG:int = 32;
      
      public static const INIT_ITEM_USER_DETAILS:int = 64;
      
      public static const INIT_ITEM_GATE_FULL:int = 128;
      
      public static const STATE_ALPHA:int = 201;
      
      public static const STATE_BETA:int = 202;
      
      public static const STATE_GAMMA:int = 203;
      
      public static const STATE_DELTA:int = 2;
      
      public static const STATE_EPSILON:int = 3;
      
      public static const STATE_ZETA:int = 4;
      
      public static const STATE_KAPPA:int = 5;
      
      public static const STATE_LAMBDA:int = 6;
      
      public static const STATE_KRONOS:int = 7;
      
      public static const STATE_HADES:int = 8;
      
      public static const STATE_STREUNER:int = 19;
      
      public static const ALPHA_GATE_PARTS_COUNT:int = 34;
      
      public static const BETA_GATE_PARTS_COUNT:int = 48;
      
      public static const GAMMA_GATE_PARTS_COUNT:int = 82;
      
      public static const DELTA_GATE_PARTS_COUNT:int = 128;
      
      public static const EPSILON_GATE_PARTS_COUNT:int = 99;
      
      public static const ZETA_GATE_PARTS_COUNT:int = 111;
      
      public static const KAPPA_GATE_PARTS_COUNT:int = 120;
      
      public static const LAMBDA_GATE_PARTS_COUNT:int = 45;
      
      public static const KRONOS_GATE_PARTS_COUNT:int = 21;
      
      public static const HADES_GATE_PARTS_COUNT:int = 45;
      
      public static const STREUNER_GATE_PARTS_COUNT:int = 100;
      
      public static const ALPHA_GATE_TOTAL_WAVES:int = 40;
      
      public static const BETA_GATE_TOTAL_WAVES:int = 40;
      
      public static const GAMMA_GATE_TOTAL_WAVES:int = 40;
      
      public static const DELTA_GATE_TOTAL_WAVES:int = 29;
      
      public static const EPSILON_GATE_TOTAL_WAVES:int = 30;
      
      public static const ZETA_GATE_TOTAL_WAVES:int = 46;
      
      public static const KAPPA_GATE_TOTAL_WAVES:int = 29;
      
      public static const LAMBDA_GATE_TOTAL_WAVES:int = 21;
      
      public static const KRONOS_GATE_TOTAL_WAVES:int = 50;
      
      public static const HADES_GATE_TOTAL_WAVES:int = 12;
      
      public static const STREUNER_GATE_TOTAL_WAVES:int = 54;
      
      public static var spinamounts:Vector.<int> = new Vector.<int>();
      
      private static const ITEMS_PREFIX:String = "items_";
      
      private static const ITEMS_FULLNAME_POSTFIX:String = "_fullname";
      
      private static const ITEMS_DESCRIPTION_POSTFIX:String = "_description";
      
      public static var spinOnSale:Boolean = false;
      
      public static var galaxyGateDay:Boolean = false;
      
      public static var bonusRewardsDay:Boolean = false;
      
      protected var freeSamples:int;
      
      protected var realMoney:Number;
      
      protected var energyCost:int;
      
      protected var output:Array = [];
      
      protected var lastPartCount:int;
      
      private var displayedGateID:int = -1;
      
      private var gates:Array;
      
      private var initComplete:Boolean = false;
      
      private var initQueue:Array;
      
      private var initIndex:int;
      
      private var initStep:int;
      
      private var errorMessage:String = "";
      
      private var _alphaAssets:IGalaxyGateBuilderAssets;
      
      private var _betaAssets:IGalaxyGateBuilderAssets;
      
      private var _gammaAssets:IGalaxyGateBuilderAssets;
      
      private var _deltaAssets:IGalaxyGateBuilderAssets;
      
      private var _epsilonAssets:IGalaxyGateBuilderAssets;
      
      private var _zetaAssets:IGalaxyGateBuilderAssets;
      
      private var _kappaAssets:IGalaxyGateBuilderAssets;
      
      private var _lambdaAssets:IGalaxyGateBuilderAssets;
      
      private var _kronosAssets:IGalaxyGateBuilderAssets;
      
      private var _hadesAssets:IGalaxyGateBuilderAssets;
      
      private var _streunerAssets:IGalaxyGateBuilderAssets;
      
      private var _currentAssets:IGalaxyGateBuilderAssets;
      
      private var helpContent:String;
      
      private var mode:int;
      
      private var gateImageLoaders:Array;
      
      private var bonusGGRewardItemImageLoaders:Array;
      
      private var applicationModes:Dictionary = new Dictionary();
      
      private var outputTypes:Dictionary = new Dictionary();
      
      private var _spinAmount:int = 1;
      
      private var _cachedBoosts:Vector.<GalaxyGateBuilderItemModule> = new Vector.<GalaxyGateBuilderItemModule>(0);
      
      private var _showGateStoryWindow:Boolean;
      
      private var _inventoryModel:InventoryModel;
      
      public function GalaxyGateBuilderModel()
      {
         super();
         this._alphaAssets = new GalaxyGateBuilderAssets("&alpha=1");
         this._betaAssets = new GalaxyGateBuilderAssets("&beta=1");
         this._gammaAssets = new GalaxyGateBuilderAssets("&gamma=1");
         this._deltaAssets = new GalaxyGateBuilderAssets("&delta=1");
         this._epsilonAssets = new GalaxyGateBuilderAssets("&epsilon=1");
         this._zetaAssets = new GalaxyGateBuilderAssets("&zeta=1");
         this._kappaAssets = new GalaxyGateBuilderAssets("&kappa=1");
         this._lambdaAssets = new GalaxyGateBuilderAssets("&lambda=1");
         this._kronosAssets = new GalaxyGateBuilderAssets("&kronos=1");
         this._hadesAssets = new GalaxyGateBuilderAssets("&hades=1");
         this._streunerAssets = new GalaxyGateBuilderAssets("&streuner=1");
      }
      
      public function init(param1:GalaxyGateBuilderDecorator) : void
      {
         this.setMode(STATE_ALPHA,true);
         this.initQueue = [];
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ASSET_PROXY);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_LIB_SIMPLE_APP);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_TRANSLATION);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_LIB_MAIN);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_LIB_GATES);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_USER_DETAILS);
         this.initQueue.push(GalaxyGateBuilderModel.INIT_ITEM_GATE_FULL);
         this.initIndex = 0;
         this.initStep = this.initQueue[this.initIndex];
         this.initApplicationModesList();
         this.initOutputTypeList();
         this.manageInitQueue();
         var _loc2_:InventoryProxy = GameFacade.getInstance().retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(!_loc2_)
         {
            GameFacade.getInstance().registerProxy(_loc2_ = new InventoryProxy());
         }
         this._inventoryModel = _loc2_.inventory;
         this._inventoryModel.itemChanged.add(this.handleItemChanged);
      }
      
      public function handleKeyDown(param1:uint) : void
      {
         var _loc2_:MaterializeEvent = null;
         var _loc3_:OutputVO = null;
         var _loc4_:MaterializeEvent = null;
         var _loc5_:OutputVO = null;
         var _loc6_:MaterializeEvent = null;
         var _loc7_:OutputVO = null;
         var _loc8_:GateVO = null;
         switch(param1)
         {
            case 70:
               break;
            case 65:
               for each(_loc8_ in this.gates)
               {
                  _loc8_.finishState = true;
                  _loc8_.partsCount = _loc8_.partsTotal;
               }
               break;
            case 49:
               dispatchEvent(new ApplicationEvent(ApplicationEvent.LOADING_ON));
               break;
            case 50:
               dispatchEvent(new ApplicationEvent(ApplicationEvent.LOADING_OFF));
               break;
            case 77:
               _loc2_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_NEW_OUTPUT);
               _loc3_ = new OutputVO(OutputVO.CAT_MULTIPLIER,2,new Date());
               _loc2_.output = _loc3_;
               dispatchEvent(_loc2_);
               break;
            case 78:
               _loc4_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_NEW_OUTPUT);
               _loc5_ = new OutputVO(OutputVO.CAT_MULTIPLIER,1,new Date());
               _loc4_.output = _loc5_;
               dispatchEvent(_loc4_);
               break;
            case 69:
               _loc6_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_NEW_OUTPUT);
               _loc7_ = new OutputVO(OutputVO.CAT_RESOURCE,150,new Date());
               _loc7_.spins = 4;
               _loc7_.multiplierUsed = 6;
               _loc7_.multiplierAmount = 40;
               _loc6_.output = _loc7_;
               dispatchEvent(_loc6_);
               break;
            case 73:
               this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + "\n(ioError simulation)";
               dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
               break;
            case 85:
               dispatchEvent(new ApplicationEvent(ApplicationEvent.URIDIUM_PURCHASE_INIT));
         }
      }
      
      public function setMode(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         if(param1 != this.mode)
         {
            this.mode = param1;
            switch(this.mode)
            {
               case STATE_DELTA:
                  this._currentAssets = this._deltaAssets;
                  _loc3_ = ApplicationEvent.STATE_DELTA;
                  break;
               case STATE_EPSILON:
                  this._currentAssets = this._epsilonAssets;
                  _loc3_ = ApplicationEvent.STATE_EPSILON;
                  break;
               case STATE_ZETA:
                  this._currentAssets = this._zetaAssets;
                  _loc3_ = ApplicationEvent.STATE_ZETA;
                  break;
               case STATE_ALPHA:
                  this._currentAssets = this._alphaAssets;
                  _loc3_ = ApplicationEvent.STATE_ALPHA;
                  break;
               case STATE_BETA:
                  this._currentAssets = this._betaAssets;
                  _loc3_ = ApplicationEvent.STATE_BETA;
                  break;
               case STATE_GAMMA:
                  this._currentAssets = this._gammaAssets;
                  _loc3_ = ApplicationEvent.STATE_GAMMA;
                  break;
               case STATE_KAPPA:
                  this._currentAssets = this._kappaAssets;
                  _loc3_ = ApplicationEvent.STATE_KAPPA;
                  break;
               case STATE_LAMBDA:
                  this._currentAssets = this._lambdaAssets;
                  _loc3_ = ApplicationEvent.STATE_LAMBDA;
                  break;
               case STATE_KRONOS:
                  this._currentAssets = this._kronosAssets;
                  _loc3_ = ApplicationEvent.STATE_KRONOS;
                  break;
               case STATE_HADES:
                  this._currentAssets = this._hadesAssets;
                  _loc3_ = ApplicationEvent.STATE_HADES;
                  break;
               case STATE_STREUNER:
                  this._currentAssets = this._streunerAssets;
                  _loc3_ = ApplicationEvent.STATE_STREUNER;
            }
            if(!param2)
            {
               dispatchEvent(new ApplicationEvent(_loc3_));
            }
         }
      }
      
      private function initApplicationModesList() : void
      {
         this.applicationModes["alpha"] = STATE_ALPHA;
         this.applicationModes["beta"] = STATE_BETA;
         this.applicationModes["gamma"] = STATE_GAMMA;
         this.applicationModes["delta"] = STATE_DELTA;
         this.applicationModes["epsilon"] = STATE_EPSILON;
         this.applicationModes["zeta"] = STATE_ZETA;
         this.applicationModes["kappa"] = STATE_KAPPA;
         this.applicationModes["lambda"] = STATE_LAMBDA;
         this.applicationModes["kronos"] = STATE_KRONOS;
         this.applicationModes["hades"] = STATE_HADES;
         this.applicationModes["streuner"] = STATE_STREUNER;
      }
      
      private function initOutputTypeList() : void
      {
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_INVALID] = OutputVO.CAT_SPLITTER;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_PART] = OutputVO.CAT_PART;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_MULTIPLIER] = OutputVO.CAT_MULTIPLIER;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_LOGFILE] = OutputVO.CAT_LOGFILES;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_VOUCHER] = OutputVO.CAT_VOUCHER;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_HITPOINTS] = OutputVO.CAT_SPECIAL;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_ORE] = OutputVO.CAT_RESOURCE;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_BATTERY] = OutputVO.CAT_AMMUNITION;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_ROCKET] = OutputVO.CAT_AMMUNITION;
         this.outputTypes[GalaxyGateBuilderItemModule.ITEMTYPE_MINE] = OutputVO.CAT_AMMUNITION;
      }
      
      private function manageInitQueue(param1:Event = null) : void
      {
         var _loc2_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         switch(this.initStep)
         {
            case GalaxyGateBuilderModel.INIT_ASSET_PROXY:
               this.setNextInitStep();
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_LIB_SIMPLE_APP:
               this.handleBackgroundLoaded();
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_TRANSLATION:
               this.showLoadingAnimation();
               this.handleLocaleLoaded();
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_LIB_MAIN:
               _loc2_.load("common",this.handleCommonAssetsLoaded,this.handleCommonAssetsLoadingError);
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_LIB_GATES:
               _loc2_.load("gates",this.handleGatesAssetsLoaded,this.handleGatesAssetsLoadingError);
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_USER_DETAILS:
               this.initUserRemote();
               break;
            case GalaxyGateBuilderModel.INIT_ITEM_GATE_FULL:
               this.getGateImageRemote(this.displayedGateID);
         }
      }
      
      private function setNextInitStep(param1:Boolean = true) : void
      {
         var _loc2_:ApplicationEvent = null;
         ++this.initIndex;
         if(this.initIndex < this.initQueue.length)
         {
            this.initStep = this.initQueue[this.initIndex];
            this.manageInitQueue();
         }
         else
         {
            this.initComplete = true;
            _loc2_ = new ApplicationEvent(ApplicationEvent.INIT_COMPLETE);
            _loc2_.data = this.displayedGateID;
            dispatchEvent(_loc2_);
            this.setGate(this.displayedGateID);
            this.hideLoadingAnimation();
            this.showCachedBoosts();
         }
      }
      
      public function setGate(param1:int) : void
      {
         var _loc2_:GateEvent = null;
         if(param1 > 0)
         {
            this.displayedGateID = param1;
            _loc2_ = new GateEvent(GateEvent.GATE_DETAILS);
            _loc2_.gateID = this.displayedGateID;
            dispatchEvent(_loc2_);
            switch(param1)
            {
               case 4:
                  this.setMode(STATE_DELTA);
                  break;
               case 5:
                  this.setMode(STATE_EPSILON);
                  break;
               case 6:
                  this.setMode(STATE_ZETA);
                  break;
               case 7:
                  this.setMode(STATE_KAPPA);
                  break;
               case 8:
                  this.setMode(STATE_LAMBDA);
                  break;
               case 12:
                  this.setMode(STATE_KRONOS);
                  break;
               case 13:
                  this.setMode(STATE_HADES);
                  break;
               case 19:
                  this.setMode(STATE_STREUNER);
                  break;
               case 1:
                  this.setMode(STATE_ALPHA);
                  break;
               case 2:
                  this.setMode(STATE_BETA);
                  break;
               case 3:
                  this.setMode(STATE_GAMMA);
            }
         }
      }
      
      private function showCachedBoosts() : void
      {
         var _loc1_:Vector.<GalaxyGateBuilderItemModule> = new Vector.<GalaxyGateBuilderItemModule>(0);
         _loc1_ = _loc1_.concat(this._cachedBoosts);
         var _loc2_:Vector.<GalaxyGateBuilderItemModule> = _loc1_;
         _loc2_.sort(this.sortOnType);
         this.parseOutputList(_loc2_,-1,null,true);
      }
      
      private function sortOnType(param1:GalaxyGateBuilderItemModule, param2:GalaxyGateBuilderItemModule) : int
      {
         var _loc3_:int = int(this.outputTypes[param1.type]);
         var _loc4_:int = int(this.outputTypes[param2.type]);
         return _loc3_ - _loc4_;
      }
      
      private function parseOutputList(param1:Vector.<GalaxyGateBuilderItemModule>, param2:int = -1, param3:Vector.<int> = null, param4:Boolean = false) : void
      {
         var _loc5_:GalaxyGateBuilderItemModule = null;
         var _loc6_:OutputVO = null;
         var _loc8_:MaterializeEvent = null;
         var _loc12_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:MaterializeEvent = null;
         var _loc22_:* = 0;
         var _loc23_:int = 0;
         var _loc24_:GalaxyGateBuilderBatteryItemModule = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:GalaxyGateBuilderLootItemModule = null;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:GalaxyGateBuilderPartItemModule = null;
         var _loc31_:int = 0;
         var _loc32_:GateVO = null;
         var _loc33_:int = 0;
         var _loc34_:GalaxyGateBuilderLootItemModule = null;
         var _loc35_:GalaxyGateBuilderLootItemModule = null;
         var _loc36_:GalaxyGateBuilderLootItemModule = null;
         var _loc37_:GalaxyGateBuilderLootItemModule = null;
         var _loc38_:GalaxyGateBuilderMultiplierItemModule = null;
         var _loc39_:MaterializeEvent = null;
         var _loc40_:int = 0;
         var _loc41_:Boolean = false;
         var _loc42_:String = null;
         var _loc43_:int = 0;
         var _loc44_:String = null;
         var _loc7_:Boolean = param1.length > 1;
         var _loc9_:int = 0;
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         var _loc13_:Date = new Date();
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 1;
         var _loc19_:Boolean = false;
         var _loc20_:OutputVO = new OutputVO(OutputVO.CAT_SPLITTER,0,_loc13_);
         var _loc21_:MaterializeEvent = new MaterializeEvent(MaterializeEvent.MATERIALIZE_NEW_OUTPUT);
         _loc21_.output = _loc20_;
         if(param2 > 0)
         {
            _loc21_.fromCache = true;
         }
         dispatchEvent(_loc21_);
         _loc22_ = int(param1.length - 1);
         while(_loc22_ >= 0)
         {
            _loc5_ = param1[_loc22_];
            if(_loc5_.type != GalaxyGateBuilderItemModule.ITEMTYPE_INVALID)
            {
               _loc18_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_NEW_OUTPUT);
               if(param2 == -1)
               {
                  _loc18_.fromCache = true;
               }
               _loc17_ = -1;
               _loc13_.setTime(Number(_loc5_.date));
               _loc12_ = false;
               _loc23_ = _loc5_.type;
               switch(_loc23_)
               {
                  case GalaxyGateBuilderItemModule.ITEMTYPE_BATTERY:
                     _loc24_ = _loc5_ as GalaxyGateBuilderBatteryItemModule;
                     _loc25_ = _loc24_.item_id;
                     _loc26_ = AmmoOutputVO.TYPE_MCB_25;
                     switch(_loc25_)
                     {
                        case 2:
                           _loc26_ = AmmoOutputVO.TYPE_MCB_25;
                           break;
                        case 3:
                           _loc26_ = AmmoOutputVO.TYPE_MCB_50;
                           break;
                        case 4:
                           _loc26_ = AmmoOutputVO.TYPE_UCB_100;
                           break;
                        case 5:
                           _loc26_ = AmmoOutputVO.TYPE_ABS;
                     }
                     _loc6_ = new AmmoOutputVO(_loc24_.amount,_loc26_,_loc13_);
                     _loc14_ = _loc24_.multiplier_amount;
                     _loc15_ = _loc24_.multiplier_used;
                     _loc16_ = _loc24_.spins;
                     _loc12_ = _loc24_.defaultOutput;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_ROCKET:
                  case GalaxyGateBuilderItemModule.ITEMTYPE_MINE:
                     _loc27_ = _loc5_ as GalaxyGateBuilderLootItemModule;
                     _loc28_ = _loc27_.item_id;
                     _loc29_ = AmmoOutputVO.TYPE_ROCKET_PLT_2121;
                     switch(_loc28_)
                     {
                        case 3:
                           _loc29_ = AmmoOutputVO.TYPE_ROCKET_PLT_2121;
                           break;
                        case 11:
                           _loc29_ = AmmoOutputVO.TYPE_MINE_ACM_1;
                     }
                     _loc6_ = new AmmoOutputVO(_loc27_.amount,_loc29_,_loc13_);
                     _loc14_ = _loc27_.multiplier_amount;
                     _loc15_ = _loc27_.multiplier_used;
                     _loc16_ = _loc27_.spins;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_PART:
                     _loc30_ = _loc5_ as GalaxyGateBuilderPartItemModule;
                     _loc31_ = _loc30_.gate_id;
                     _loc32_ = this.getGateVO(_loc31_);
                     _loc17_ = _loc30_.duplicate ? 1 : 0;
                     _loc15_ = _loc30_.multiplier_used;
                     _loc33_ = _loc30_.part_id;
                     if(_loc30_.current != 0 && _loc32_.partsTotal != 0 && _loc32_.partsCount != _loc30_.current && _loc30_.current == _loc32_.partsTotal)
                     {
                        this.errorMessage = BPLocale.getItemInCategory("galaxyGates","gate_finished").replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + int(_loc31_)));
                        _loc19_ = true;
                     }
                     if(_loc17_ == 1)
                     {
                        _loc6_ = new PartOutputVO(_loc13_,_loc33_,_loc31_);
                        _loc39_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_DUPLICATE_PART);
                        _loc39_.output = _loc6_;
                        if(param2 == 1)
                        {
                           _loc39_.showMessage = true;
                           this.errorMessage = BPLocale.getItemInCategory("galaxyGates","msg_produced_part_single_duplicate").replace(/%PART_ID%/,_loc33_).replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + _loc31_)).replace(/%MULTIPLIER%/,this.getMultiplierValue() + 1);
                           dispatchEvent(_loc39_);
                           return;
                        }
                     }
                     else
                     {
                        _loc40_ = _loc30_.current;
                        if(!param4)
                        {
                           if(_loc32_.partsCount < _loc40_)
                           {
                              _loc32_.partsCount = _loc40_;
                           }
                           _loc10_.push(_loc33_);
                           if(_loc11_.indexOf(_loc31_) == -1)
                           {
                              _loc11_.push(_loc31_);
                           }
                           _loc41_ = _loc30_.state == GalaxyGateBuilderPartItemModule.GATESTATE_FINISHED;
                           if(!_loc32_.finishState && _loc41_)
                           {
                              _loc32_.finishState = true;
                              _loc32_.livesLeft = _loc30_.livesLeft;
                              _loc32_.lifePrice = _loc30_.lifePrice;
                           }
                        }
                        _loc6_ = new PartOutputVO(_loc13_,_loc33_,_loc31_);
                        _loc32_.gateImage = null;
                        _loc32_.lastPartImage = null;
                        this.lastPartCount = 1;
                        _loc40_++;
                        _loc9_ = _loc31_;
                     }
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_VOUCHER:
                     _loc34_ = _loc5_ as GalaxyGateBuilderLootItemModule;
                     _loc6_ = new OutputVO(OutputVO.CAT_VOUCHER,_loc34_.amount,_loc13_);
                     _loc14_ = _loc34_.multiplier_amount;
                     _loc15_ = _loc34_.multiplier_used;
                     _loc16_ = _loc34_.spins;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_ORE:
                     _loc35_ = _loc5_ as GalaxyGateBuilderLootItemModule;
                     _loc6_ = new OutputVO(OutputVO.CAT_RESOURCE,_loc35_.amount,_loc13_);
                     _loc14_ = _loc35_.multiplier_amount;
                     _loc15_ = _loc35_.multiplier_used;
                     _loc16_ = _loc35_.spins;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_HITPOINTS:
                     _loc36_ = _loc5_ as GalaxyGateBuilderLootItemModule;
                     _loc6_ = new SpecialOutputVO(_loc36_.amount,SpecialOutputVO.TYPE_NANOHULL,_loc13_);
                     _loc14_ = _loc36_.multiplier_amount;
                     _loc15_ = _loc36_.multiplier_used;
                     _loc16_ = _loc36_.spins;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_LOGFILE:
                     _loc37_ = _loc5_ as GalaxyGateBuilderLootItemModule;
                     _loc6_ = new OutputVO(OutputVO.CAT_LOGFILES,_loc37_.amount,_loc13_);
                     _loc14_ = _loc37_.multiplier_amount;
                     _loc15_ = _loc37_.multiplier_used;
                     _loc16_ = _loc37_.spins;
                     break;
                  case GalaxyGateBuilderItemModule.ITEMTYPE_MULTIPLIER:
                     _loc38_ = _loc5_ as GalaxyGateBuilderMultiplierItemModule;
                     _loc6_ = new OutputVO(OutputVO.CAT_MULTIPLIER,_loc38_.amount,_loc13_);
                     break;
                  default:
                     throw Error("This type is not handled : " + _loc23_);
               }
            }
            if(_loc7_)
            {
               _loc6_.quiet = true;
            }
            if(_loc14_ > 0)
            {
               _loc6_.multiplierAmount = _loc14_;
            }
            if(_loc15_ > 0)
            {
               _loc6_.multiplierUsed = _loc15_;
            }
            if(_loc16_ > 0)
            {
               _loc6_.spins = _loc16_;
            }
            if(_loc17_ < 1)
            {
               _loc18_.output = _loc6_;
               dispatchEvent(_loc18_);
            }
            _loc22_--;
         }
         if(_loc9_ > 0 && param2 > 0)
         {
            this.loadGateImage(_loc9_,param3,false);
         }
         else
         {
            dispatchEvent(new MaterializeEvent(MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON));
         }
         if(_loc19_)
         {
            _loc8_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_SHOW_MESSAGE);
            dispatchEvent(_loc8_);
         }
         if(_loc6_ != null && (_loc7_ || _loc12_) && param2 == 1)
         {
            this.errorMessage = BPLocale.getItemInCategory("galaxyGates","msg_produced_parts");
            _loc42_ = BPLocale.getItemInCategory("galaxyGates","msg_produced_partslist_item");
            _loc43_ = int(_loc10_.length);
            _loc22_ = 0;
            while(_loc22_ < _loc43_)
            {
               this.errorMessage += " " + _loc42_.replace(/%PART_ID%/,_loc10_[_loc22_]) + ",";
               _loc22_++;
            }
            if(_loc43_ > 0)
            {
               this.errorMessage = this.errorMessage.substring(0,this.errorMessage.length - 1);
            }
            if(_loc12_)
            {
               if(_loc7_)
               {
                  this.errorMessage += "\n" + BPLocale.getItemInCategory("galaxyGates","msg_produced_mutliplier_default_additional");
               }
               else
               {
                  this.errorMessage += "\n" + BPLocale.getItemInCategory("galaxyGates","msg_produced_mutliplier_default_no_parts");
               }
               this.errorMessage += "\n" + _loc6_.toString();
            }
            _loc44_ = "";
            _loc43_ = int(_loc11_.length);
            _loc22_ = 0;
            while(_loc22_ < _loc43_)
            {
               _loc44_ += BPLocale.getItemInCategory("galaxyGates","gate_name_" + _loc11_[_loc22_]);
               if(_loc22_ < _loc43_ - 1)
               {
                  _loc44_ += ", ";
               }
               else if(_loc43_ > 1)
               {
                  _loc44_ += " " + BPLocale.getItemInCategory("galaxyGates","and") + " ";
               }
               _loc22_++;
            }
            this.errorMessage = this.errorMessage.replace(/%COUNT%/,_loc10_.length).replace(/%GATE_NAME%/,_loc44_);
            _loc8_ = new MaterializeEvent(MaterializeEvent.MATERIALIZE_MULTIPLE_PART_OUTPUT);
            dispatchEvent(_loc8_);
         }
      }
      
      private function isGateIdValid(param1:int) : Boolean
      {
         var _loc3_:String = null;
         if(this.gates == null || this.gates.length == 0)
         {
            return false;
         }
         var _loc2_:String = param1.toString();
         for(_loc3_ in this.gates)
         {
            if(_loc3_.indexOf(_loc2_) >= 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function handleBackgroundLoaded(param1:ImageFinisher = null) : void
      {
         dispatchEvent(new DataTransferEvent(DataTransferEvent.PRELOAD_BACKGROUND_COMPLETE));
         this.setNextInitStep();
      }
      
      private function handleBackgroundLoadingError(param1:ImageFinisher = null) : void
      {
         this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + "\n(Error on loading background)";
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
      }
      
      private function handleLocaleLoaded() : void
      {
         BPLocale.thousandsSeparator = BPLocale.getItemInCategory("galaxyGates","thousands_separator");
         BPLocale.decimalMark = BPLocale.getItemInCategory("galaxyGates","decimal_separator");
         BPLocale.setItemInCategory("galaxyGates","gate_finished",BPLocale.getItemInCategory("galaxyGates","label_gate_finished"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_1",BPLocale.getItemInCategory("galaxyGates","gate_title_alpha"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_2",BPLocale.getItemInCategory("galaxyGates","gate_title_beta"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_3",BPLocale.getItemInCategory("galaxyGates","gate_title_gamma"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_4",BPLocale.getItemInCategory("galaxyGates","gate_title_delta"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_5",BPLocale.getItemInCategory("galaxyGates","gate_title_epsilon"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_6",BPLocale.getItemInCategory("galaxyGates","gate_title_zeta"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_7",BPLocale.getItemInCategory("galaxyGates","gate_title_kappa"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_8",BPLocale.getItemInCategory("galaxyGates","gate_title_lambda"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_12",BPLocale.getItemInCategory("galaxyGates","gate_title_kronos"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_13",BPLocale.getItemInCategory("galaxyGates","gate_title_hades"));
         BPLocale.setItemInCategory("galaxyGates","gate_title_19",BPLocale.getItemInCategory("galaxyGates","gate_title_streuner"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_1",BPLocale.getItemInCategory("galaxyGates","gate_name_alpha"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_2",BPLocale.getItemInCategory("galaxyGates","gate_name_beta"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_3",BPLocale.getItemInCategory("galaxyGates","gate_name_gamma"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_4",BPLocale.getItemInCategory("galaxyGates","gate_name_delta"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_5",BPLocale.getItemInCategory("galaxyGates","gate_name_epsilon"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_6",BPLocale.getItemInCategory("galaxyGates","gate_name_zeta"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_7",BPLocale.getItemInCategory("galaxyGates","gate_name_kappa"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_8",BPLocale.getItemInCategory("galaxyGates","gate_name_lambda"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_12",BPLocale.getItemInCategory("galaxyGates","gate_name_kronos"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_13",BPLocale.getItemInCategory("galaxyGates","gate_name_hades"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_19",BPLocale.getItemInCategory("galaxyGates","gate_name_streuner"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_1",BPLocale.getItemInCategory("galaxyGates","gate_name_alpha_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_2",BPLocale.getItemInCategory("galaxyGates","gate_name_beta_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_3",BPLocale.getItemInCategory("galaxyGates","gate_name_gamma_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_4",BPLocale.getItemInCategory("galaxyGates","gate_name_delta_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_5",BPLocale.getItemInCategory("galaxyGates","gate_name_epsilon_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_6",BPLocale.getItemInCategory("galaxyGates","gate_name_zeta_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_7",BPLocale.getItemInCategory("galaxyGates","gate_name_kappa_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_8",BPLocale.getItemInCategory("galaxyGates","gate_name_lambda_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_12",BPLocale.getItemInCategory("galaxyGates","gate_name_kronos_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_13",BPLocale.getItemInCategory("galaxyGates","gate_name_hades_long"));
         BPLocale.setItemInCategory("galaxyGates","gate_name_long_19",BPLocale.getItemInCategory("galaxyGates","gate_name_streuner_long"));
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LANGUAGE_LOADED));
         this.setNextInitStep();
      }
      
      private function handleCommonAssetsLoaded(param1:SWFFinisher = null) : void
      {
         dispatchEvent(new DataTransferEvent(DataTransferEvent.MAIN_LIB_LOADED));
         this.setNextInitStep();
      }
      
      private function handleCommonAssetsLoadingError(param1:Event = null) : void
      {
         this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + "\n(Error on Loading Main Gfx Library)";
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
      }
      
      private function handleGatesAssetsLoaded(param1:SWFFinisher = null) : void
      {
         dispatchEvent(new DataTransferEvent(DataTransferEvent.GATES_LIB_LOADED));
         this.setNextInitStep();
      }
      
      private function handleGatesAssetsLoadingError(param1:Event = null) : void
      {
         this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + "\n(Error on Loading Gates Gfx Library)";
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
      }
      
      private function initUserRemote() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GalaxyGateBuilderInfoRequest());
      }
      
      public function handleInitUserComplete(param1:GalaxyGateBuilderInfoCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.parseInitUserData(param1);
         this.setNextInitStep();
      }
      
      private function handleInitUserError() : void
      {
         this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + " ( Error: User could not be initialised by System)Log out and log in again.";
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
      }
      
      private function parseInitUserData(param1:GalaxyGateBuilderInfoCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:GalaxyGateBuilderGateModule = null;
         var _loc5_:int = 0;
         var _loc6_:GateVO = null;
         var _loc7_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.realMoney = param1.money;
         this.freeSamples = param1.samples;
         this.energyCost = param1.energy_cost;
         this._spinAmount = param1.spinamount_selected;
         this._showGateStoryWindow = true;
         spinOnSale = param1.spinOnSale;
         galaxyGateDay = param1.galaxyGateDay;
         bonusRewardsDay = param1.bonusRewardsDay;
         for each(_loc2_ in param1.spinAmounts)
         {
            GalaxyGateBuilderModel.spinamounts.push(_loc2_);
         }
         this.gates = new Array(MAX_GATES_COUNT);
         this.gateImageLoaders = new Array(MAX_GATES_COUNT);
         this.bonusGGRewardItemImageLoaders = [];
         for each(_loc4_ in param1.gates)
         {
            ++MAX_GATES_COUNT;
            _loc5_ = _loc4_.id;
            if(this.displayedGateID == -1 || this.displayedGateID > _loc5_)
            {
               this.displayedGateID = _loc5_;
            }
            if(_loc5_ == 1)
            {
               MODE_GATES.push([1,2,3]);
            }
            else if(_loc5_ > 3)
            {
               _loc3_ = [_loc5_];
               MODE_GATES.push(_loc3_);
            }
            _loc6_ = new GateVO(_loc4_.currPart,this.getGateMaxPartsCount(_loc5_),_loc4_.livesLeft,_loc4_.lifePrice,_loc4_.state == GalaxyGateBuilderGateModule.GATESTATE_FINISHED);
            _loc6_.totalWave = this.getGateTotalWaves(_loc5_);
            _loc6_.currentWave = _loc4_.currWave;
            if(_loc4_.multiGateProgressModules != null && _loc4_.multiGateProgressModules.length > 0)
            {
               _loc6_.parseGateProgress(_loc4_.multiGateProgressModules);
               _loc6_.handleLastPart = false;
            }
            if(_loc4_.bonusGGRewardModules != null && _loc4_.bonusGGRewardModules.length > 0)
            {
               _loc6_.parseBonusGGReward(_loc4_.bonusGGRewardModules);
            }
            this.gates[_loc5_ - 1] = _loc6_;
            _loc7_ = int(this.applicationModes[_loc4_.mode]);
            this.initProbabilitySet(_loc4_.probabilityModules,_loc7_);
            this.setMultiplierDataAt(_loc4_.multiplier,_loc4_.multiplier >= 5,_loc7_);
         }
         MODE_GATES.sort(GateVO.sortModeGates);
         this.setMode(this.applicationModes["alpha"],true);
         dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
         this._cachedBoosts = _loc4_.boosts;
      }
      
      private function getGateMaxPartsCount(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return ALPHA_GATE_PARTS_COUNT;
            case 2:
               return BETA_GATE_PARTS_COUNT;
            case 3:
               return GAMMA_GATE_PARTS_COUNT;
            case 4:
               return DELTA_GATE_PARTS_COUNT;
            case 5:
               return EPSILON_GATE_PARTS_COUNT;
            case 6:
               return ZETA_GATE_PARTS_COUNT;
            case 7:
               return KAPPA_GATE_PARTS_COUNT;
            case 8:
               return LAMBDA_GATE_PARTS_COUNT;
            case 12:
               return KRONOS_GATE_PARTS_COUNT;
            case 13:
               return HADES_GATE_PARTS_COUNT;
            case 19:
               return STREUNER_GATE_PARTS_COUNT;
            default:
               return 1;
         }
      }
      
      private function getGateTotalWaves(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return ALPHA_GATE_TOTAL_WAVES;
            case 2:
               return BETA_GATE_TOTAL_WAVES;
            case 3:
               return GAMMA_GATE_TOTAL_WAVES;
            case 4:
               return DELTA_GATE_TOTAL_WAVES;
            case 5:
               return EPSILON_GATE_TOTAL_WAVES;
            case 6:
               return ZETA_GATE_TOTAL_WAVES;
            case 7:
               return KAPPA_GATE_TOTAL_WAVES;
            case 8:
               return LAMBDA_GATE_TOTAL_WAVES;
            case 12:
               return KRONOS_GATE_TOTAL_WAVES;
            case 13:
               return HADES_GATE_TOTAL_WAVES;
            case 19:
               return STREUNER_GATE_TOTAL_WAVES;
            default:
               return 1;
         }
      }
      
      private function getGateImageRemote(param1:int) : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GalaxyGateBuilderGetGatePartsRequest(param1));
      }
      
      public function loadGateImage(param1:int, param2:Vector.<int>, param3:Boolean) : void
      {
         var _loc4_:int = param1 - 1;
         if(!this.isGateIdValid(_loc4_))
         {
            return;
         }
         var _loc5_:GateImageLoader = this.gateImageLoaders[_loc4_] as GateImageLoader;
         if(_loc5_ == null)
         {
            _loc5_ = new GateImageLoader(param1,this.getGateMaxPartsCount(param1));
            this.gateImageLoaders[_loc4_] = _loc5_;
         }
         if(!_loc5_.isLoading)
         {
            _loc5_.partIds = param2;
            _loc5_.fromGetPartsCmd = param3;
            _loc5_.loaded.add(this.handleGateImageLoaded);
            _loc5_.load();
         }
         else if(!param3)
         {
            dispatchEvent(new MaterializeEvent(MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON));
         }
      }
      
      private function compareGateId(param1:int) : Boolean
      {
         if(param1 <= 3 && this.displayedGateID <= 3)
         {
            return true;
         }
         return param1 == this.displayedGateID;
      }
      
      private function handleGateImageLoaded(param1:int, param2:Boolean) : void
      {
         var _loc5_:GateEvent = null;
         var _loc3_:GateImageLoader = this.gateImageLoaders[param1 - 1] as GateImageLoader;
         _loc3_.loaded.remove(this.handleGateImageLoaded);
         var _loc4_:GateVO = this.getGateVO(param1);
         if(_loc4_)
         {
            _loc4_.gateImage = _loc3_.gateBitmap;
            _loc4_.lastPartImage = _loc3_.lastPartBitmap;
         }
         if(this.initComplete)
         {
            if(param2)
            {
               if(param1 == this.displayedGateID)
               {
                  _loc5_ = new GateEvent(GateEvent.GATE_DETAILS);
                  _loc5_.gateID = param1;
                  dispatchEvent(_loc5_);
               }
            }
            else
            {
               if(this.compareGateId(param1))
               {
                  _loc5_ = new GateEvent(GateEvent.GATE_PROGRESS);
                  _loc5_.gateID = param1;
                  dispatchEvent(_loc5_);
               }
               dispatchEvent(new MaterializeEvent(MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON));
            }
         }
         else
         {
            this.setNextInitStep();
         }
      }
      
      public function handleGateImageError(param1:int, param2:int) : void
      {
         var _loc3_:GateVO = null;
         switch(param2)
         {
            case GalaxyGateBuilderGetGatePartsCommand.ERRORCODE_UNCLASSIFIED_ERROR:
               this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error") + "\n( Error at Updating Gate Image )";
               dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
               _loc3_ = this.getGateVO(param1);
               if(_loc3_)
               {
                  _loc3_.gateImage = null;
                  _loc3_.lastPartImage = null;
               }
         }
      }
      
      private function getGatesProgressList() : Array
      {
         var _loc1_:GateVO = this.gates[this.displayedGateID - 1] as GateVO;
         return _loc1_.gateProgressList;
      }
      
      public function getKronosGatenames() : String
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc1_:String = "";
         var _loc2_:Array = this.getGatesProgressList();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.name;
            _loc1_ += "<h3>" + _loc4_ + "</h3>";
         }
         return _loc1_;
      }
      
      public function getKronosGateProgress() : String
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:String = "";
         var _loc2_:Array = this.getGatesProgressList();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = int(_loc3_.current);
            _loc5_ = int(_loc3_.total);
            if(_loc4_ == _loc5_)
            {
               _loc1_ += "<h2>" + _loc4_ + " / " + _loc5_ + "</h2>";
            }
            else
            {
               _loc1_ += "<h1>" + _loc4_ + " / " + _loc5_ + "</h1>";
            }
         }
         return _loc1_;
      }
      
      public function get showGateStoryWindow() : Boolean
      {
         return this._showGateStoryWindow;
      }
      
      public function showAdditionalInformationDialog() : void
      {
         if(this._currentAssets == this._hadesAssets || this._currentAssets == this._streunerAssets)
         {
            dispatchEvent(new Event(ApplicationEvent.ADDITIONALWINDOW_SHOW));
         }
      }
      
      public function isHadesGate() : Boolean
      {
         return this.displayedGateID == 13;
      }
      
      public function getGateBonusReward(param1:int) : GateBonusGGRewardVO
      {
         return this.getGateVO(param1).bonusGGReward;
      }
      
      public function getUridium() : Number
      {
         return this.realMoney;
      }
      
      public function purchaseUridium() : void
      {
         JavascriptProxy.referToURL("internalPayment","seo_tittle_uridium");
         dispatchEvent(new ApplicationEvent(ApplicationEvent.URIDIUM_PURCHASE_COMPLETE));
      }
      
      private function handleItemChanged() : void
      {
         var _loc1_:Vector.<ItemVO> = this._inventoryModel.getById("currency_uridium");
         if(_loc1_.length > 0)
         {
            this.realMoney = _loc1_[0].amount;
            dispatchEvent(new ApplicationEvent(ApplicationEvent.URIDIUM_UPDATE));
         }
      }
      
      public function getProgress() : String
      {
         var _loc1_:GateVO = this.gates[this.displayedGateID - 1] as GateVO;
         var _loc2_:String = "";
         return _loc2_ + (_loc1_.partsCount + "/" + _loc1_.partsTotal);
      }
      
      public function getLivesLeft() : int
      {
         return (this.gates[this.displayedGateID - 1] as GateVO).livesLeft;
      }
      
      public function getLifePrice() : int
      {
         return (this.gates[this.displayedGateID - 1] as GateVO).lifePrice;
      }
      
      public function getTotalWaveCount() : int
      {
         return (this.gates[this.displayedGateID - 1] as GateVO).totalWave;
      }
      
      public function getCurrentWaveCount() : int
      {
         return (this.gates[this.displayedGateID - 1] as GateVO).currentWave;
      }
      
      public function getHandleLastPart(param1:int) : Boolean
      {
         return this.getGateVO(param1).handleLastPart;
      }
      
      public function getGateState() : Boolean
      {
         return (this.gates[this.displayedGateID - 1] as GateVO).finishState;
      }
      
      public function isGateComplete(param1:int) : Boolean
      {
         var _loc2_:GateVO = this.getGateVO(param1);
         return _loc2_.partsTotal - _loc2_.partsCount <= 0;
      }
      
      public function initGateLifePurchase(param1:int) : void
      {
         var _loc2_:GateEvent = new GateEvent(GateEvent.GATE_LIFE_PURCHASE_INIT);
         _loc2_.gateID = param1;
         dispatchEvent(_loc2_);
      }
      
      public function purchaseGateLife() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GalaxyGateBuilderBuyLifeRequest(this.displayedGateID));
      }
      
      public function handleGateLifePurchaseComplete(param1:GalaxyGateBuilderBuyLifeCommand) : void
      {
         this.parseGateLifePurchaseResponse(param1);
      }
      
      private function parseGateLifePurchaseResponse(param1:GalaxyGateBuilderBuyLifeCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.errorCode == GalaxyGateBuilderBuyLifeCommand.ERRORCODE_NOT_ENOUGH_MONEY)
         {
            this.errorMessage = BPLocale.getItemInCategory("galaxyGates","msg_not_enough_uridium");
            dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
            return;
         }
         this.realMoney = param1.money;
         this.freeSamples = param1.samples;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.NUMBERS_UPDATE));
         this.setMultiplierDataAt(param1.multiplier,param1.multiplier >= 5,this.applicationModes[param1.gateMode]);
         var _loc2_:GateVO = this.getGateVO(param1.gateId);
         _loc2_.livesLeft = param1.livesLeft;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
         _loc2_.lifePrice = param1.lifePrice;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LIFE_PRICE_UPDATE));
         dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
         if((_loc2_.livesLeft == -1 || _loc2_.lifePrice == -1) && _loc2_.partsCount == _loc2_.partsTotal)
         {
            _loc2_.finishState = true;
         }
         dispatchEvent(new ApplicationEvent(ApplicationEvent.JUMP_BUTTON_VISIBILITY));
         if(param1.errorCode == GalaxyGateBuilderBuyLifeCommand.ERRORCODE_UNCLASSIFIED_ERROR)
         {
            this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error");
            dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
            return;
         }
         var _loc3_:GateEvent = new GateEvent(GateEvent.GATE_LIFE_PURCHASE_COMPLETE);
         _loc3_.gateID = param1.gateId;
         dispatchEvent(_loc3_);
      }
      
      public function getExtraEnergy() : int
      {
         return this.freeSamples;
      }
      
      public function getEnergyCost() : int
      {
         return this.energyCost;
      }
      
      public function produce() : void
      {
         this.produceRemote();
      }
      
      private function produceRemote() : void
      {
         if(!this.validateTotalEnergyCost())
         {
            return;
         }
         var _loc1_:GalaxyGateBuilderMultiEnergyRequest = new GalaxyGateBuilderMultiEnergyRequest(this.displayedGateID,this.getMultiplierState(),this._spinAmount);
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
         dispatchEvent(new ApplicationEvent(ApplicationEvent.MATERIALIZE));
      }
      
      public function parseProduceResponse(param1:GalaxyGateBuilderMultiEnergyCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.errorCode > 0)
         {
            switch(param1.errorCode)
            {
               case GalaxyGateBuilderMultiEnergyCommand.ERRORCODE_NOT_ENOUGH_MONEY:
                  this.errorMessage = BPLocale.getItemInCategory("galaxyGates","msg_not_enough_uridium");
                  dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
                  break;
               default:
                  this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error");
                  dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
            }
            return;
         }
         this.realMoney = param1.money;
         this.freeSamples = param1.samples;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.NUMBERS_UPDATE));
         this.setMultiplierDataAt(param1.multiplier,param1.multiplier >= 5,this.applicationModes[param1.gateMode]);
         param1.items.sort(this.sortOnType);
         this.parseOutputList(param1.items,param1.spinamount_selected,param1.gatePartIds);
      }
      
      public function setSpinAmount(param1:int) : void
      {
         var _loc2_:ApplicationEvent = null;
         if(this._spinAmount == param1)
         {
            return;
         }
         if(GalaxyGateBuilderModel.spinamounts.indexOf(param1) == -1)
         {
            param1 = 1;
         }
         this._spinAmount = param1;
         if(this.initComplete)
         {
            _loc2_ = new ApplicationEvent(ApplicationEvent.SPIN_AMOUNT_UPDATE);
            dispatchEvent(_loc2_);
         }
         this.validateTotalEnergyCost();
         this.saveSpinAmountRemote();
      }
      
      private function validateTotalEnergyCost() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._spinAmount - this.freeSamples;
         if(_loc2_ <= 0)
         {
            _loc1_ = 0;
         }
         else
         {
            _loc1_ = _loc2_ * this.energyCost;
         }
         if(_loc1_ > 0 && _loc1_ > this.realMoney)
         {
            dispatchEvent(new ApplicationEvent(ApplicationEvent.URIDIUM_PURCHASE_INIT));
            return false;
         }
         return true;
      }
      
      public function getSpinAmount() : int
      {
         return this._spinAmount;
      }
      
      private function saveSpinAmountRemote() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GalaxyGateBuilderSaveSpinAmountRequest(this._spinAmount));
      }
      
      public function getGateVO(param1:int) : GateVO
      {
         return this.gates[param1 - 1] as GateVO;
      }
      
      public function getGateImages(param1:int) : GateVO
      {
         var _loc2_:GateVO = this.getGateVO(param1);
         if(_loc2_.gateImage == null || _loc2_.lastPartImage == null)
         {
            this.getGateImageRemote(param1);
            _loc2_.gateImage = new Bitmap();
            _loc2_.lastPartImage = new Bitmap();
         }
         return _loc2_;
      }
      
      public function getItemImage(param1:int) : Bitmap
      {
         var _loc3_:Bitmap = null;
         var _loc2_:GateVO = this.getGateVO(param1);
         if(_loc2_.bonusGGReward.rewardImage == null)
         {
            this.getItemImageRemote(param1,_loc2_.bonusGGReward.lootId);
            _loc3_ = new Bitmap();
         }
         else
         {
            _loc3_ = _loc2_.bonusGGReward.rewardImage;
         }
         return _loc3_;
      }
      
      public function getItemImageRemote(param1:int, param2:String) : void
      {
         var _loc3_:ItemImageLoader = this.bonusGGRewardItemImageLoaders[param2] as ItemImageLoader;
         if(_loc3_ == null)
         {
            _loc3_ = new ItemImageLoader(param1,param2);
            this.bonusGGRewardItemImageLoaders[param2] = _loc3_;
         }
         _loc3_.loaded.add(this.handleItemImageComplete);
         _loc3_.load();
      }
      
      private function handleItemImageComplete(param1:int, param2:String) : void
      {
         var _loc5_:GateEvent = null;
         var _loc3_:ItemImageLoader = this.bonusGGRewardItemImageLoaders[param2] as ItemImageLoader;
         _loc3_.loaded.remove(this.handleItemImageComplete);
         var _loc4_:GateVO = this.getGateVO(param1);
         if(_loc4_ != null && _loc4_.bonusGGReward != null && _loc4_.bonusGGReward.lootId == param2)
         {
            _loc4_.bonusGGReward.rewardImage = _loc3_.bitmap;
         }
         if(this.initComplete)
         {
            if(param1 == this.displayedGateID)
            {
               _loc5_ = new GateEvent(GateEvent.GATE_DETAILS);
               _loc5_.gateID = this.displayedGateID;
               dispatchEvent(_loc5_);
            }
         }
      }
      
      public function prepareJump() : void
      {
         this.prepareJumpRemote();
      }
      
      private function prepareJumpRemote() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GalaxyGateBuilderSetupGateRequest(this.displayedGateID));
      }
      
      public function handlePrepareJumpComplete(param1:GalaxyGateBuilderSetupGateCommand) : void
      {
         var _loc4_:GateEvent = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1.id;
         var _loc3_:GateVO = this.gates[_loc2_ - 1];
         if(_loc3_ != null)
         {
            _loc3_.livesLeft = param1.livesLeft;
            _loc3_.lifePrice = param1.lifePrice;
            _loc3_.finishState = false;
            _loc3_.partsCount = 0;
            _loc3_.gateImage = null;
            _loc3_.lastPartImage = null;
            _loc4_ = new GateEvent(GateEvent.GATE_DETAILS);
            _loc4_.gateID = _loc2_;
            dispatchEvent(_loc4_);
            this.errorMessage = BPLocale.getItemInCategory("galaxyGates","msg_gate_active").replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + (param1.id + 0)));
            dispatchEvent(new GateEvent(GateEvent.GATE_SETUP));
            dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
            dispatchEvent(new ApplicationEvent(ApplicationEvent.LIFE_PRICE_UPDATE));
            dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
            if(param1.errorCode > 0)
            {
               switch(param1.errorCode)
               {
                  case GalaxyGateBuilderSetupGateCommand.ERRORCODE_UNCLASSIFIED_ERROR:
                     this.errorMessage = BPLocale.getItemInCategory("galaxyGates","unclassified_error");
                     dispatchEvent(new ApplicationEvent(ApplicationEvent.HOLD));
               }
            }
         }
      }
      
      public function getHelp() : String
      {
         if(this.helpContent == null || this.helpContent == "")
         {
            this.helpContent = "<p>" + BPLocale.getItemInCategory("faq","galaxygates_caption_p") + "</p>";
            this.helpContent += "<br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_main_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_main_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_output_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_output_list_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_output_duplicate_part_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_output_repair_vouchers_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_output_nanohull_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_spins_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_spins_main_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_spins_multiplier_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_main_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_leave_caption_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_leave_on_kill_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_leave_after_wave_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_pvemap_leave_after_completion_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_multiplier_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_multiplier_main_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_multiplier_maximum_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_multiplier_multilpier_on_parts_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_costs_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_costs_main_p") + "</p>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_costs_discount_p") + "</p>";
            this.helpContent += "<br /><br /><span class=\"h2\">" + BPLocale.getItemInCategory("faq","galaxygates_hadesgate_h") + "</span>";
            this.helpContent += "<br /><p>" + BPLocale.getItemInCategory("faq","galaxygates_hadesgate_main_p") + "</p><br /><br />";
         }
         return this.helpContent;
      }
      
      public function showHelp() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HELP_ON));
      }
      
      public function hideHelp() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.HELP_OFF));
      }
      
      private function initProbabilitySet(param1:Vector.<GalaxyGateBuilderProbabilityModule>, param2:int) : void
      {
         var _loc4_:GalaxyGateBuilderProbabilityModule = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:ProbabilityVO = new ProbabilityVO();
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_.category;
            _loc6_ = _loc4_.percentage;
            _loc7_ = 0;
            switch(_loc5_)
            {
               case GalaxyGateBuilderProbabilityModule.CATEGORY_AMMUNITION:
                  _loc7_ = ProbabilityVO.INDEX_AMMUNITION;
                  break;
               case GalaxyGateBuilderProbabilityModule.CATEGORY_RESOURCE:
                  _loc7_ = ProbabilityVO.INDEX_RESOURCE;
                  break;
               case GalaxyGateBuilderProbabilityModule.CATEGORY_VOUCHER:
                  _loc7_ = ProbabilityVO.INDEX_VOUCHER;
                  break;
               case GalaxyGateBuilderProbabilityModule.CATEGORY_PART:
                  _loc7_ = ProbabilityVO.INDEX_PART;
                  break;
               case GalaxyGateBuilderProbabilityModule.CATEGORY_SPECIAL:
                  _loc7_ = ProbabilityVO.INDEX_SPECIAL;
                  break;
               case GalaxyGateBuilderProbabilityModule.CATEGORY_LOGFILE:
                  _loc7_ = ProbabilityVO.INDEX_LOGFILES;
                  break;
               default:
                  _loc7_ = -1;
            }
            if(_loc7_ != -1)
            {
               _loc3_.setProbability(_loc7_,_loc6_);
            }
         }
         if(param2 == STATE_ALPHA)
         {
            this._alphaAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_BETA)
         {
            this._betaAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_GAMMA)
         {
            this._gammaAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_DELTA)
         {
            this._deltaAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_EPSILON)
         {
            this._epsilonAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_ZETA)
         {
            this._zetaAssets.setProbability(_loc3_);
         }
         else if(param2 == STATE_STREUNER)
         {
            this._streunerAssets.setProbability(_loc3_);
         }
      }
      
      public function getProbability() : ProbabilityVO
      {
         return this._currentAssets.getProbability();
      }
      
      public function showProbability() : void
      {
         var _loc1_:GateEvent = new GateEvent(GateEvent.GATE_SHOW_PROBABILITY);
         _loc1_.gateID = this.displayedGateID;
         dispatchEvent(_loc1_);
      }
      
      private function setMultiplierDataAt(param1:int, param2:Boolean, param3:int) : void
      {
         var _loc4_:IGalaxyGateBuilderAssets = null;
         switch(param3)
         {
            case STATE_ALPHA:
               _loc4_ = this._alphaAssets;
               break;
            case STATE_BETA:
               _loc4_ = this._betaAssets;
               break;
            case STATE_GAMMA:
               _loc4_ = this._gammaAssets;
               break;
            case STATE_DELTA:
               _loc4_ = this._deltaAssets;
               break;
            case STATE_EPSILON:
               _loc4_ = this._epsilonAssets;
               break;
            case STATE_ZETA:
               _loc4_ = this._zetaAssets;
               break;
            case STATE_KAPPA:
               _loc4_ = this._kappaAssets;
               break;
            case STATE_LAMBDA:
               _loc4_ = this._lambdaAssets;
               break;
            case STATE_HADES:
               _loc4_ = this._hadesAssets;
               break;
            case STATE_STREUNER:
               _loc4_ = this._streunerAssets;
         }
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:Boolean = false;
         if(this.mode == param3)
         {
            if(param1 != _loc4_.getMultiplierValue() || param2 != _loc4_.getMultiplierState())
            {
               _loc5_ = true;
            }
         }
         _loc4_.setMultiplierState(param2);
         _loc4_.setMultiplierValue(param1);
         if(_loc5_)
         {
            dispatchEvent(new MultiplierEvent(MultiplierEvent.CHANGE));
         }
      }
      
      public function getMultiplierValue() : int
      {
         return this._currentAssets.getMultiplierValue();
      }
      
      public function getMultiplierState() : Boolean
      {
         return this._currentAssets.getMultiplierState();
      }
      
      public function setMultiplierState(param1:Boolean) : void
      {
         if(this._currentAssets.getMultiplierState() != param1)
         {
            this._currentAssets.setMultiplierState(param1);
            dispatchEvent(new MultiplierEvent(MultiplierEvent.CHANGE));
         }
      }
      
      private function parseRewards(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.@mode;
            _loc4_ = int(this.applicationModes[_loc3_]);
            this.setRewardDataAt(_loc4_,_loc2_.items.item);
         }
      }
      
      private function setRewardDataAt(param1:int, param2:XMLList) : void
      {
         var _loc3_:IGalaxyGateBuilderAssets = null;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         switch(param1)
         {
            case STATE_ALPHA:
               _loc3_ = this._alphaAssets;
               break;
            case STATE_BETA:
               _loc3_ = this._betaAssets;
               break;
            case STATE_GAMMA:
               _loc3_ = this._gammaAssets;
               break;
            case STATE_DELTA:
               _loc3_ = this._deltaAssets;
               break;
            case STATE_EPSILON:
               _loc3_ = this._epsilonAssets;
               break;
            case STATE_ZETA:
               _loc3_ = this._zetaAssets;
               break;
            case STATE_KAPPA:
               _loc3_ = this._kappaAssets;
               break;
            case STATE_LAMBDA:
               _loc3_ = this._lambdaAssets;
               break;
            case STATE_HADES:
               _loc3_ = this._hadesAssets;
               break;
            case STATE_STREUNER:
               _loc3_ = this._streunerAssets;
         }
         var _loc4_:Array = [];
         for each(_loc5_ in param2)
         {
            _loc6_ = _loc5_.@lootID;
            _loc7_ = _loc5_.@value;
            _loc8_ = BPLocale.getItemInCategory("items",ITEMS_PREFIX + _loc6_ + ITEMS_FULLNAME_POSTFIX);
            _loc9_ = BPLocale.getItemInCategory("items",ITEMS_PREFIX + _loc6_ + ITEMS_DESCRIPTION_POSTFIX);
            _loc10_ = {
               "id":_loc6_,
               "text":_loc8_,
               "description":_loc9_,
               "value":_loc7_
            };
            _loc4_.push(_loc10_);
         }
         _loc3_.setRewards(_loc4_);
      }
      
      public function getCurrentRewardData() : Array
      {
         return this._currentAssets.getRewards();
      }
      
      public function showReward() : void
      {
         var _loc1_:ApplicationEvent = new ApplicationEvent(ApplicationEvent.REWARD_SHOW);
         _loc1_.data = this.displayedGateID;
         dispatchEvent(_loc1_);
      }
      
      public function hideReward() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.REWARD_HIDE));
      }
      
      public function updateGateComplete(param1:GalaxyGateBuilderGateCompleteCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:GateVO = this.getGateVO(param1.gateId);
         _loc2_.partsCount = param1.currPart;
         _loc2_.livesLeft = -1;
         _loc2_.lifePrice = -1;
         if((_loc2_.livesLeft == -1 || _loc2_.lifePrice == -1) && _loc2_.partsCount == _loc2_.partsTotal)
         {
            _loc2_.finishState = true;
         }
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LIFE_PRICE_UPDATE));
         dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
         dispatchEvent(new ApplicationEvent(ApplicationEvent.JUMP_BUTTON_VISIBILITY));
      }
      
      public function updateGateLifeLost(param1:GalaxyGateBuilderGateLifeLostCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:GateVO = this.getGateVO(param1.gateId);
         _loc2_.livesLeft = param1.livesLeft;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
      }
      
      public function updateGateWaves(param1:GalaxyGateBuilderGateWaveUpdateCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:GateVO = this.getGateVO(param1.gateId);
         _loc2_.currentWave = param1.currWave;
         dispatchEvent(new ApplicationEvent(ApplicationEvent.WAVES_UPDATE));
      }
      
      protected function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getLastOutput() : String
      {
         var _loc1_:String = new Date().toString();
         if(this.output.length == 0)
         {
            _loc1_ += "; kein Output produziert";
         }
         else
         {
            _loc1_ += "; " + this.lastPartCount + " neue teile prudiziert, " + this.output[this.output.length - 1];
         }
         return _loc1_;
      }
      
      public function getLootText(param1:String) : String
      {
         return BPLocale.getItemInCategory("items",ITEMS_PREFIX + param1 + ITEMS_FULLNAME_POSTFIX);
      }
      
      public function setAppRunning() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.RUN));
      }
      
      public function getErrorMessage() : String
      {
         return this.errorMessage;
      }
      
      public function showLoadingAnimation() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LOADING_ON));
      }
      
      public function hideLoadingAnimation() : void
      {
         dispatchEvent(new ApplicationEvent(ApplicationEvent.LOADING_OFF));
      }
      
      public function get currentAssets() : IGalaxyGateBuilderAssets
      {
         return this._currentAssets;
      }
      
      public function get streunerAssets() : IGalaxyGateBuilderAssets
      {
         return this._streunerAssets;
      }
      
      public function get hadesAssets() : IGalaxyGateBuilderAssets
      {
         return this._hadesAssets;
      }
   }
}

