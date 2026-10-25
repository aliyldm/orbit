package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.LabRefinementRequest;
   import net.bigpoint.darkorbit.com.module.LabUpdateRequest;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RefinerInfo;
   import org.puremvc.as3.multicore.patterns.facade.Facade;
   
   public class RefinementManager implements IFrameObserver
   {
      
      private var _facade:Facade;
      
      private var _guiManager:GuiManager;
      
      private var refinementButton:ButtonElement;
      
      private var updateButton:ButtonElement;
      
      private var oreIDToProduce:int;
      
      private var _tpf:Number = 0;
      
      private var timerRepeat:Number = 0;
      
      public function RefinementManager(param1:GuiManager)
      {
         super();
         this._guiManager = param1;
         this._facade = GameFacade.getInstance();
         this.createRefinementWindow();
         this.refreshItemList();
      }
      
      public static function getItemTypeString(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = "LASER";
               break;
            case 1:
               _loc2_ = "ROCKET";
               break;
            case 2:
               _loc2_ = "DRIVING";
               break;
            case 3:
               _loc2_ = "SHIELD";
         }
         return _loc2_;
      }
      
      public static function getItemTypeUint(param1:String) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case "LASER":
               _loc2_ = 0;
               break;
            case "ROCKET":
               _loc2_ = 1;
               break;
            case "DRIVING":
               _loc2_ = 2;
               break;
            case "SHIELD":
               _loc2_ = 3;
         }
         return _loc2_;
      }
      
      public function updateOreCounts() : void
      {
         var _loc1_:Array = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:OrePattern = null;
         var _loc7_:StaticRefinementModule = null;
         var _loc8_:SourceRefinementModule = null;
         var _loc9_:StaticRefinementModule = null;
         var _loc10_:StaticRefinementModule = null;
         _loc1_ = Ore.getOres([OreTypeModule.ORETYPE_PROMETIUM,OreTypeModule.ORETYPE_ENDURIUM,OreTypeModule.ORETYPE_TERBIUM,OreTypeModule.ORETYPE_XENOMIT,OreTypeModule.ORETYPE_PALLADIUM]);
         _loc2_ = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         _loc3_ = _loc2_.getAllElements();
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc7_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc7_.setOreCount(_loc6_.count);
               _loc7_.updateAmmount();
            }
            _loc5_++;
         }
         _loc1_ = Ore.getOres([OreTypeModule.ORETYPE_PROMETID,OreTypeModule.ORETYPE_DURANIUM,OreTypeModule.ORETYPE_PROMERIUM,OreTypeModule.ORETYPE_SEPROM,OreTypeModule.ORETYPE_OSMIUM]);
         _loc2_ = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         _loc3_ = _loc2_.getAllElements();
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is SourceRefinementModule)
            {
               _loc8_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc8_.setOreCount(_loc6_.count);
               _loc8_.updateAmmount();
            }
            _loc5_++;
         }
         _loc2_ = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         _loc3_ = _loc2_.getAllElements();
         _loc1_ = Ore.getOres([OreTypeModule.ORETYPE_PROMETIUM,OreTypeModule.ORETYPE_ENDURIUM,OreTypeModule.ORETYPE_TERBIUM]);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc9_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc9_.setOreCount(_loc6_.count);
               _loc9_.updateAmmount();
            }
            _loc5_++;
         }
         _loc2_ = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         _loc3_ = _loc2_.getAllElements();
         _loc1_ = Ore.getOres([OreTypeModule.ORETYPE_PROMETID,OreTypeModule.ORETYPE_DURANIUM,OreTypeModule.ORETYPE_PROMERIUM,OreTypeModule.ORETYPE_XENOMIT]);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc10_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc10_.setOreCount(_loc6_.count);
               _loc10_.updateAmmount();
            }
            _loc5_++;
         }
      }
      
      public function updateItem(param1:String, param2:int, param3:int) : void
      {
         var _loc6_:OreIcon = null;
         var _loc4_:TargetRefinementModule = this.getTargetRefinementModule(param1);
         if(_loc4_ != null)
         {
            _loc4_.setAmmount(param3);
         }
         var _loc5_:SourceRefinementModule = this.getSourceRefinementModule(param2);
         if(_loc5_ != null)
         {
            _loc4_.removeOreIcon();
            if(param3 > 0)
            {
               _loc6_ = _loc5_.createOreIcon();
               _loc4_.setOreIcon(_loc6_);
            }
         }
      }
      
      private function getTargetRefinementModule(param1:String) : TargetRefinementModule
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:TargetRefinementModule = null;
         var _loc2_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
            _loc4_ = _loc3_.getAllElements();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_] is TargetRefinementModule)
               {
                  _loc6_ = _loc4_[_loc5_];
                  if(_loc6_.identifier == param1)
                  {
                     return _loc6_;
                  }
               }
               _loc5_++;
            }
         }
         return null;
      }
      
      private function getSourceRefinementModule(param1:int) : SourceRefinementModule
      {
         var _loc6_:SourceRefinementModule = null;
         var _loc2_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_] is SourceRefinementModule)
            {
               _loc6_ = _loc4_[_loc5_];
               if(_loc6_.type == param1)
               {
                  return _loc6_;
               }
            }
            _loc5_++;
         }
         return null;
      }
      
      private function onRefinementTab(param1:MouseEvent) : void
      {
         this.setVisibility(true);
      }
      
      private function onUpdateTab(param1:MouseEvent) : void
      {
         this.setVisibility(false);
         this.updateOreCounts();
      }
      
      private function setVisibility(param1:Boolean) : void
      {
         var _loc2_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         var _loc4_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc5_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc6_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         var _loc7_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         var _loc8_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_BUTTONS);
         var _loc9_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_TREE);
         _loc6_.visible = param1;
         _loc7_.visible = param1;
         _loc8_.visible = param1;
         _loc9_.visible = param1;
         this.refinementButton.selected = param1;
         _loc3_.visible = !param1;
         _loc4_.visible = !param1;
         _loc5_.visible = !param1;
         this.updateButton.selected = !param1;
      }
      
      public function createRefinementWindow() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:SimpleElement = null;
         var _loc5_:Sprite = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = this._guiManager.createWindow(GuiConstants.REFINEMENT_WINDOW) as SimpleWindow;
            _loc1_.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onRefinementWindowMaximized);
            _loc1_.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.onRefinementWindowMinimized);
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc3_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_BUTTONS);
            this.refinementButton = new ButtonElement(ButtonElementTypes.TYPE_REFINEMENT_REFINEMENT,BPLocale.getItem("lab_btn_refinement"),_loc2_.getEmbeddedMovieClip("button1"));
            this.refinementButton.selected = true;
            this.refinementButton.addEventListener(MouseEvent.CLICK,this.onRefinementTab);
            _loc3_.addElement(this.refinementButton);
            this.updateButton = new ButtonElement(ButtonElementTypes.TYPE_REFINEMENT_UPDATE,BPLocale.getItem("lab_btn_update"),_loc2_.getEmbeddedMovieClip("button1"));
            this.updateButton.addEventListener(MouseEvent.CLICK,this.onUpdateTab);
            _loc3_.addElement(this.updateButton,SimpleContainer.ALIGN_HORIZONTAL);
            _loc4_ = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(1,8289918);
            _loc5_.graphics.moveTo(0,0);
            _loc5_.graphics.lineTo(434,0);
            _loc4_.addChild(_loc5_);
            _loc4_.y = 20;
            _loc3_.addElement(_loc4_,SimpleContainer.NO_ALIGN,0);
            _loc1_.addContainer(_loc3_);
            this.createRefinementContainers();
            this.createUpdateContainers();
            if(_loc1_.maximized)
            {
               this.startRefreshTimer();
            }
         }
      }
      
      private function onRefinementWindowMaximized(param1:SimpleWindowEvent) : void
      {
         this.killRefreshTimer();
         this.startRefreshTimer();
         this.refreshItemList();
      }
      
      private function onRefinementWindowMinimized(param1:Event) : void
      {
         this.killRefreshTimer();
      }
      
      private function startRefreshTimer() : void
      {
         ScreenManager.addObserver(this);
      }
      
      private function handleTimerComplete() : void
      {
         var _loc1_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         this.killRefreshTimer();
         _loc1_.minimize(true);
      }
      
      private function killRefreshTimer() : void
      {
         this.timerRepeat = 0;
         ScreenManager.removeObserver(this);
      }
      
      public function updateTimer(param1:Number) : void
      {
         this._tpf += param1;
         if(this._tpf > 999)
         {
            this.refreshItemList();
            ++this.timerRepeat;
            if(this.timerRepeat > 599)
            {
               this.handleTimerComplete();
            }
            this._tpf = 0;
         }
      }
      
      private function refreshItemList() : void
      {
         var _loc1_:LabUpdateRequest = new LabUpdateRequest();
         this._facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      private function createRefinementContainers() : void
      {
         var _loc8_:int = 0;
         var _loc9_:OrePattern = null;
         var _loc10_:String = null;
         var _loc11_:XML = null;
         var _loc12_:SimpleContainer = null;
         var _loc13_:SimpleContainer = null;
         var _loc14_:StaticRefinementModule = null;
         var _loc15_:StaticRefinementModule = null;
         var _loc16_:int = 0;
         var _loc17_:StaticRefinementModule = null;
         var _loc18_:String = null;
         var _loc19_:Array = null;
         var _loc20_:RefinerInfo = null;
         var _loc21_:OrePattern = null;
         var _loc22_:Boolean = false;
         var _loc23_:StaticRefinementModule = null;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:ButtonElement = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc3_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_TREE);
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
         _loc4_.addChild(_loc2_.getEmbeddedBitmap("ore_tree"));
         _loc3_.addElement(_loc4_);
         _loc1_.addContainer(_loc3_);
         var _loc5_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         var _loc6_:int = 0;
         var _loc7_:int = 8;
         for each(_loc11_ in Main.gameXML.refinementWindow.refinement.staticOres.ore)
         {
            _loc8_ = parseInt(_loc11_.attribute("type"));
            _loc9_ = PatternManager.orePatterns[_loc8_];
            _loc10_ = null;
            if(_loc11_.attribute("tooltipKey").length() > 0)
            {
               _loc10_ = BPLocale.getItem(_loc11_.attribute("tooltipKey"));
            }
            _loc17_ = new StaticRefinementModule(this,_loc8_,_loc9_.languageKey,_loc9_.resKey,_loc10_);
            _loc17_.x = _loc6_;
            _loc17_.y = 40;
            _loc6_ = _loc6_ + _loc17_.background.width + _loc7_;
            _loc5_.addElement(_loc17_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc5_);
         _loc12_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         _loc13_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_BUTTONS);
         _loc6_ = 0;
         _loc7_ = 8;
         for each(_loc11_ in Main.gameXML.refinementWindow.refinement.ores.ore)
         {
            _loc8_ = parseInt(_loc11_.attribute("type"));
            _loc9_ = PatternManager.orePatterns[_loc8_];
            _loc10_ = null;
            _loc18_ = _loc11_.attribute("tooltipKey");
            if(_loc18_.length > 0)
            {
               _loc24_ = _loc18_.split(",");
               if(_loc24_.length > 1)
               {
                  _loc10_ = "";
                  _loc25_ = 0;
                  while(_loc25_ < _loc24_.length)
                  {
                     _loc10_ += BPLocale.getItem(_loc24_[_loc25_]) + "\n";
                     _loc25_++;
                  }
               }
               else
               {
                  _loc10_ = BPLocale.getItem(_loc11_.attribute("tooltipKey"));
               }
            }
            _loc19_ = _loc9_.refiners;
            if(_loc19_[0])
            {
               _loc20_ = _loc19_[0];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT_1%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE_1%",BPLocale.getItem(_loc21_.languageKey));
            }
            if(_loc19_[1])
            {
               _loc20_ = _loc19_[1];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT_2%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE_2%",BPLocale.getItem(_loc21_.languageKey));
            }
            if(_loc19_[2])
            {
               _loc20_ = _loc19_[2];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE%",BPLocale.getItem(_loc21_.languageKey));
            }
            _loc22_ = false;
            if(_loc11_.attribute("button").length() > 0)
            {
               _loc22_ = ParserUtility.parseBooleanFromString(_loc11_.attribute("button"));
            }
            _loc23_ = new StaticRefinementModule(this,_loc8_,_loc9_.languageKey,_loc9_.resKey,_loc10_);
            _loc23_.x = _loc6_;
            _loc23_.y = 55;
            if(_loc22_)
            {
               _loc26_ = new ButtonElement(ButtonElementTypes.TYPE_REFINEMENT_REFINEMENT,BPLocale.getItem("lab_btn_refine"),_loc2_.getEmbeddedMovieClip("button1"));
               _loc26_.addEventListener(MouseEvent.CLICK,this.onRefine);
               _loc26_.width = _loc23_.width;
               _loc26_.y = 100;
               _loc23_.addChild(_loc26_);
            }
            _loc6_ = _loc6_ + _loc23_.background.width + _loc7_;
            _loc12_.addElement(_loc23_,SimpleContainer.NO_ALIGN,1);
         }
         _loc14_ = StaticRefinementModule(_loc12_.getElementAt(2));
         _loc14_.y = 215;
         _loc14_.x = 42;
         _loc15_ = StaticRefinementModule(_loc12_.getElementAt(3));
         _loc15_.x = 220;
         _loc16_ = _loc12_.width > _loc5_.width ? int(_loc12_.width) : int(_loc5_.width);
         _loc12_.x = _loc3_.x = 260 - _loc16_ / 2;
         _loc5_.x = _loc12_.x - 47;
         _loc1_.addContainer(_loc12_);
         _loc1_.addContainer(_loc13_);
      }
      
      private function onRefine(param1:MouseEvent) : void
      {
         var _loc6_:SimpleContainer = null;
         var _loc7_:TextFieldElement = null;
         var _loc8_:TextFieldElement = null;
         var _loc9_:ComboBoxElement = null;
         var _loc10_:SWFFinisher = null;
         var _loc11_:ButtonElement = null;
         var _loc12_:ButtonElement = null;
         var _loc2_:ButtonElement = param1.currentTarget as ButtonElement;
         var _loc3_:StaticRefinementModule = _loc2_.parent as StaticRefinementModule;
         this.oreIDToProduce = _loc3_.type;
         var _loc4_:PointLite = this.hackXWindowPosition(GuiConstants.REFINEMENT_WINDOW);
         var _loc5_:SimpleWindow = this.guiManager.createWindow(GuiConstants.REFINEMENT_REFINE_WINDOW,new SimpleWindowCreationVO(GuiConstants.REFINEMENT_REFINE_WINDOW,null,1,_loc4_)) as SimpleWindow;
         if(_loc5_)
         {
            _loc6_ = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_DEFAULT);
            _loc6_.x = 20;
            _loc6_.y = 35;
            _loc7_ = new TextFieldElement(200,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getItem(_loc3_.languageKey),TextFormatAlign.LEFT);
            _loc6_.addElement(_loc7_);
            _loc8_ = new TextFieldElement(200,20,new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,16777215),BPLocale.getItem("lab_refine_question"),TextFormatAlign.LEFT);
            _loc6_.addElement(_loc8_,SimpleContainer.ALIGN_VERTICAL);
            _loc9_ = new ComboBoxElement(this.guiManager);
            _loc6_.addElement(_loc9_,SimpleContainer.ALIGN_VERTICAL);
            this.fillComboBox(_loc3_.type,_loc9_);
            _loc10_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc11_ = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("lab_btn_refine"),_loc10_.getEmbeddedMovieClip("button1"));
            _loc11_.addEventListener(MouseEvent.CLICK,this.onOkBtn);
            _loc6_.addElement(_loc11_);
            _loc11_.y = 90;
            _loc12_ = new ButtonElement(ButtonElementTypes.TYPE_CANCEL,BPLocale.getItem("lab_cancel"),_loc10_.getEmbeddedMovieClip("button1"));
            _loc12_.addEventListener(MouseEvent.CLICK,this.onCancelBtn);
            _loc6_.addElement(_loc12_,SimpleContainer.ALIGN_HORIZONTAL);
            _loc5_.addContainer(_loc6_);
            _loc5_.activateModalLayer(true);
         }
         else
         {
            _loc5_ = this.guiManager.getWindow(GuiConstants.REFINEMENT_REFINE_WINDOW);
            if(_loc5_)
            {
               _loc5_.maximize(false);
            }
         }
      }
      
      private function onOkBtn(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.getWindow(GuiConstants.REFINEMENT_REFINE_WINDOW);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_DEFAULT);
         var _loc4_:ComboBoxElement = ComboBoxElement(_loc3_.getElement(SimpleElement.TYPE_COMBO_BOX_ELEMENT));
         var _loc5_:int = parseInt(_loc4_.comboBox.selectedLabel);
         var _loc6_:LabRefinementRequest = new LabRefinementRequest();
         _loc6_.toProduce.count = _loc5_;
         _loc6_.toProduce.oreType.typeValue = uint(this.oreIDToProduce);
         this.guiManager.getMain().getConnectionManager().sendRequest(_loc6_);
         this.closeRefinePopup();
      }
      
      private function onCancelBtn(param1:MouseEvent) : void
      {
         this.closeRefinePopup();
      }
      
      private function closeRefinePopup() : void
      {
         var _loc5_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.guiManager.getWindow(GuiConstants.REFINEMENT_REFINE_WINDOW);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT);
         var _loc3_:Array = _loc2_.getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.getType() == ButtonElementTypes.TYPE_OK)
            {
               _loc5_.removeEventListener(MouseEvent.CLICK,this.onOkBtn);
            }
            if(_loc5_.getType() == ButtonElementTypes.TYPE_CANCEL)
            {
               _loc5_.removeEventListener(MouseEvent.CLICK,this.onCancelBtn);
            }
            _loc4_++;
         }
         this.guiManager.closeWindow(_loc1_);
      }
      
      private function fillComboBox(param1:int, param2:ComboBoxElement) : void
      {
         var _loc11_:OrePattern = null;
         var _loc3_:OrePattern = PatternManager.orePatterns[param1];
         var _loc4_:Array = _loc3_.refiners;
         var _loc5_:RefinerInfo = _loc4_[0];
         var _loc6_:RefinerInfo = _loc4_[1];
         var _loc7_:RefinerInfo = _loc4_[2];
         var _loc8_:OrePattern = PatternManager.orePatterns[_loc5_.oreID];
         var _loc9_:OrePattern = PatternManager.orePatterns[_loc6_.oreID];
         var _loc10_:int = Math.min(_loc8_.count / _loc5_.count,_loc9_.count / _loc6_.count);
         if(_loc7_)
         {
            _loc11_ = PatternManager.orePatterns[_loc7_.oreID];
            _loc10_ = Math.min(_loc10_,_loc11_.count / _loc7_.count);
         }
         param2.setAvailableAmmount(_loc10_);
      }
      
      private function createUpdateContainers() : void
      {
         var _loc6_:int = 0;
         var _loc7_:OrePattern = null;
         var _loc8_:XML = null;
         var _loc9_:SimpleContainer = null;
         var _loc10_:TextFieldElement = null;
         var _loc11_:SimpleContainer = null;
         var _loc12_:XML = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:StaticRefinementModule = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:SourceRefinementModule = null;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:TargetRefinementModule = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         _loc2_.visible = false;
         var _loc3_:TextFieldElement = new TextFieldElement(340,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getItem("lab_title"),TextFormatAlign.LEFT);
         _loc2_.addElement(_loc3_);
         var _loc4_:int = 0;
         var _loc5_:int = 8;
         for each(_loc8_ in Main.gameXML.refinementWindow.update.staticOres.ore)
         {
            _loc6_ = parseInt(_loc8_.attribute("type"));
            _loc7_ = PatternManager.orePatterns[_loc6_];
            _loc14_ = null;
            if(_loc8_.attribute("tooltipKey").length() > 0)
            {
               _loc14_ = BPLocale.getItem(_loc8_.attribute("tooltipKey"));
            }
            _loc15_ = new StaticRefinementModule(this,_loc6_,_loc7_.languageKey,_loc7_.resKey,_loc14_);
            _loc15_.x = _loc4_;
            _loc15_.y = 40;
            _loc4_ = _loc4_ + _loc15_.background.width + _loc5_;
            _loc2_.addElement(_loc15_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc2_);
         _loc9_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         _loc9_.visible = false;
         _loc10_ = new TextFieldElement(340,40,new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,16777215),BPLocale.getItem("labor_intro"),TextFormatAlign.LEFT);
         _loc9_.addElement(_loc10_);
         _loc4_ = 0;
         _loc5_ = 8;
         for each(_loc8_ in Main.gameXML.refinementWindow.update.ores.ore)
         {
            _loc6_ = parseInt(_loc8_.attribute("type"));
            _loc7_ = PatternManager.orePatterns[_loc6_];
            _loc16_ = _loc8_.attribute("iconResKey");
            _loc17_ = _loc8_.attribute("tooltipKey");
            _loc18_ = new SourceRefinementModule(this,_loc6_,_loc7_.languageKey,_loc7_.resKey,_loc16_,_loc17_);
            _loc18_.x = _loc4_;
            _loc18_.y = 55;
            _loc4_ = _loc4_ + _loc18_.background.width + _loc5_;
            _loc9_.addElement(_loc18_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc9_);
         _loc11_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         _loc11_.visible = false;
         _loc4_ = 0;
         for each(_loc12_ in Main.gameXML.refinementWindow.update.items.item)
         {
            _loc19_ = parseInt(_loc12_.attribute("type"));
            _loc20_ = _loc12_.attribute("languageKey");
            _loc21_ = _loc12_.attribute("resKey");
            _loc22_ = _loc12_.attribute("identifier");
            _loc23_ = _loc12_.attribute("ammountKey");
            _loc24_ = new TargetRefinementModule(this,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_);
            _loc24_.x = _loc4_;
            _loc4_ = _loc4_ + _loc24_.background.width + _loc5_;
            _loc11_.addElement(_loc24_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc11_);
         _loc13_ = _loc11_.width > _loc9_.width ? int(_loc11_.width) : int(_loc9_.width);
         _loc9_.x = _loc11_.x = 230 - _loc13_ / 2;
      }
      
      public function get guiManager() : GuiManager
      {
         return this._guiManager;
      }
      
      public function hackXWindowPosition(param1:String) : PointLite
      {
         var _loc2_:SimpleWindow = this._guiManager.getWindow(param1);
         var _loc3_:Number = _loc2_.x + _loc2_.width / 2;
         var _loc4_:Number = ScreenManager.getScreenWidth();
         var _loc5_:Number = 100 * _loc3_ / _loc4_;
         return new PointLite(_loc5_,50);
      }
   }
}

