package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.LabUpdateItemRequest;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SourceRefinementModule extends RefinementModule
   {
      
      private var _iconResKey:String;
      
      private var _oreCount:int = 0;
      
      private var currentIdentifier:String;
      
      private var tooltipKey:String;
      
      public function SourceRefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String, param5:String, param6:String = null)
      {
         super(param1,param2,param3,param4);
         this._iconResKey = param5;
         this.tooltipKey = param6;
         this.init();
         this.buttonMode = true;
      }
      
      public function createOreIcon() : OreIcon
      {
         var _loc1_:Bitmap = finisher.getEmbeddedBitmap(this._iconResKey);
         return new OreIcon(this.type,_loc1_,this.tooltipKey);
      }
      
      public function updateAmmount() : void
      {
         labelAmmount.setText(this._oreCount.toString());
      }
      
      public function setOreCount(param1:int) : void
      {
         this._oreCount = param1;
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = null;
         _background = finisher.getEmbeddedBitmap("sourceSlot");
         this.addChild(_background);
         _loc1_ = finisher.getEmbeddedBitmap(resKey);
         _loc1_.x = _background.width / 2 - _loc1_.width / 2;
         _loc1_.y = _background.height / 2 - _loc1_.height / 2;
         this.addChild(_loc1_);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         setLabels();
         this.setAmmount(0);
         if(this.tooltipKey != null)
         {
            TooltipControl.getInstance().addToolTip(this,BPLocale.getItem(this.tooltipKey));
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc6_:TargetRefinementModule = null;
         if(this._oreCount == 0)
         {
            return;
         }
         var _loc2_:SimpleContainer = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc3_:Array = _loc2_.getAllElements();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] is TargetRefinementModule)
            {
               _loc6_ = _loc3_[_loc4_];
               if(this.isValid(_loc6_))
               {
                  _loc6_.highlight();
               }
            }
            _loc4_++;
         }
         var _loc5_:MovieClip = this.createIcon();
         _loc5_.startDrag();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         var _loc9_:TargetRefinementModule = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:TargetRefinementModule = null;
         var _loc4_:SimpleContainer = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc5_:Array = _loc4_.getAllElements();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc5_[_loc6_] is TargetRefinementModule)
            {
               _loc9_ = _loc5_[_loc6_];
               _loc9_.removeHighlight();
               if(_loc4_.mouseX > _loc9_.x && _loc4_.mouseX < _loc9_.x + _loc9_.width && _loc4_.mouseY > _loc9_.y && _loc4_.mouseY < _loc9_.y + _loc9_.height)
               {
                  _loc3_ = _loc9_;
               }
            }
            _loc6_++;
         }
         if(!this.isValid(_loc3_))
         {
            this.moveToSource(_loc2_);
            return;
         }
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var _loc7_:SimpleWindow = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         MovieClipUtils.removeDisplayObject(_loc2_);
         this.currentIdentifier = _loc3_.identifier;
         var _loc8_:Number = Math.min(_loc3_.maxAmount * 0.1,this._oreCount);
         if(_loc3_.oreIcon == null)
         {
            this.createCountWindow(_loc8_);
         }
         else if(_loc3_.oreIcon.id == type)
         {
            this.createCountWindow(_loc8_);
         }
         else
         {
            this.createUpdateWindow(Math.min(TargetRefinementModule.MAX_VALUE * 0.1,this._oreCount));
         }
      }
      
      private function isValid(param1:TargetRefinementModule) : Boolean
      {
         return !(param1 == null || param1.oreType == this.type && param1.maxAmount < 10 || this.type == OreTypeModule.ORETYPE_PROMETID && param1.identifier == "SHIELD" || this.type == OreTypeModule.ORETYPE_PROMETID && param1.identifier == "DRIVING" || this.type == OreTypeModule.ORETYPE_DURANIUM && param1.identifier == "LASER" || this.type == OreTypeModule.ORETYPE_DURANIUM && param1.identifier == "ROCKET" || this.type == OreTypeModule.ORETYPE_SEPROM && param1.identifier == "DRIVING" || this.type == OreTypeModule.ORETYPE_OSMIUM && param1.identifier == "DRIVING");
      }
      
      private function createCountWindow(param1:Number) : void
      {
         var _loc2_:SimpleWindow = null;
         if(param1 < 1)
         {
            return;
         }
         _loc2_ = refinementManager.guiManager.createWindow(GuiConstants.REFINEMENT_COUNT_WINDOW,new SimpleWindowCreationVO(GuiConstants.REFINEMENT_REFINE_WINDOW,ScreenManager.getInstance().getWindowLayer2())) as SimpleWindow;
         var _loc3_:SimpleContainer = new SimpleContainer(refinementManager.guiManager,SimpleContainer.CLASS_DEFAULT);
         _loc3_.x = 20;
         _loc3_.y = 35;
         var _loc4_:TextFieldElement = new TextFieldElement(340,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getItem("lab_count"),TextFormatAlign.LEFT);
         _loc3_.addElement(_loc4_);
         var _loc5_:ComboBoxElement = new ComboBoxElement(refinementManager.guiManager);
         _loc5_.setAvailableAmmount(param1);
         _loc3_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL);
         _loc3_.y = 30;
         var _loc6_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc7_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("lab_update"),_loc6_.getEmbeddedMovieClip("button1"));
         _loc7_.addEventListener(MouseEvent.CLICK,this.onOkCountWindow);
         _loc3_.addElement(_loc7_);
         _loc7_.y = 60;
         var _loc8_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL,BPLocale.getItem("lab_cancel"),_loc6_.getEmbeddedMovieClip("button1"));
         _loc3_.addElement(_loc8_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc8_.y = 60;
         _loc8_.addEventListener(MouseEvent.CLICK,this.onCloseCountWindow);
         _loc2_.addContainer(_loc3_);
         _loc2_.activateModalLayer(true);
      }
      
      private function onOkCountWindow(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_COUNT_WINDOW);
         var _loc3_:ComboBoxElement = ComboBoxElement(_loc2_.getContainer(SimpleContainer.CLASS_DEFAULT).getElement(SimpleElement.TYPE_COMBO_BOX_ELEMENT));
         var _loc4_:int = parseInt(_loc3_.comboBox.selectedLabel);
         var _loc5_:LabUpdateItemRequest = new LabUpdateItemRequest();
         _loc5_.itemToUpdate.itemValue = RefinementManager.getItemTypeUint(this.currentIdentifier);
         _loc5_.updateWith.oreType.typeValue = type;
         _loc5_.updateWith.count = _loc4_;
         _refinementManager.guiManager.getMain().getConnectionManager().sendRequest(_loc5_);
         this.closeCountWindow();
      }
      
      private function onCloseCountWindow(param1:MouseEvent) : void
      {
         this.closeCountWindow();
      }
      
      private function closeCountWindow() : void
      {
         var _loc4_:ButtonElement = null;
         var _loc1_:SimpleWindow = refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_COUNT_WINDOW);
         var _loc2_:Array = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT).getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.getType() == ButtonElementTypes.TYPE_CANCEL)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onCloseCountWindow);
            }
            if(_loc4_.getType() == ButtonElementTypes.TYPE_OK)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onOkCountWindow);
            }
            _loc3_++;
         }
         refinementManager.guiManager.closeWindow(_loc1_,false);
         refinementManager.guiManager.deleteWindow(_loc1_.id);
      }
      
      private function createUpdateWindow(param1:Number) : void
      {
         var tfHeader:TextFieldElement;
         var finisher:SWFFinisher;
         var updateButton:ButtonElement;
         var cancelButton:ButtonElement;
         var max:Number = param1;
         var window:SimpleWindow = refinementManager.guiManager.createWindow(GuiConstants.REFINEMENT_UPDATE_WINDOW) as SimpleWindow;
         var container:SimpleContainer = new SimpleContainer(refinementManager.guiManager,SimpleContainer.CLASS_DEFAULT);
         container.x = 20;
         container.y = 35;
         tfHeader = new TextFieldElement(340,50,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getItem("lab_alert"),TextFormatAlign.LEFT);
         container.addElement(tfHeader);
         finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         updateButton = new ButtonElement(ButtonElementTypes.TYPE_UPDATE,BPLocale.getItem("lab_update"),finisher.getEmbeddedMovieClip("button1"));
         updateButton.y = container.y + 10;
         updateButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            closeUpdateWindow();
            createCountWindow(max);
         },false,0,true);
         container.addElement(updateButton,SimpleContainer.ALIGN_VERTICAL);
         cancelButton = new ButtonElement(ButtonElementTypes.TYPE_CANCEL,BPLocale.getItem("lab_cancel"),finisher.getEmbeddedMovieClip("button1"));
         cancelButton.y = container.y + 10;
         container.addElement(cancelButton,SimpleContainer.ALIGN_HORIZONTAL);
         cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelUpdate);
         window.addContainer(container);
         window.activateModalLayer(true);
      }
      
      private function onCancelUpdate(param1:MouseEvent) : void
      {
         this.closeUpdateWindow();
      }
      
      private function closeUpdateWindow() : void
      {
         var _loc4_:ButtonElement = null;
         var _loc1_:SimpleWindow = refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_UPDATE_WINDOW);
         var _loc2_:Array = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT).getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.getType() == ButtonElementTypes.TYPE_UPDATE)
            {
            }
            if(_loc4_.getType() == ButtonElementTypes.TYPE_CANCEL)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onCancelUpdate);
            }
            _loc3_++;
         }
         refinementManager.guiManager.closeWindow(_loc1_);
      }
      
      private function moveToSource(param1:MovieClip) : void
      {
         var _loc2_:SimpleContainer = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc3_:SimpleWindow = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc4_:int = _loc3_.x + _loc2_.x + this.x + this.width / 2;
         var _loc5_:int = _loc3_.y + _loc2_.y + this.y + this.height / 2;
         TweenLite.to(param1,0.25,{
            "alpha":0,
            "x":_loc4_,
            "y":_loc5_,
            "onComplete":this.onResetIcon,
            "onCompleteParams":[param1]
         });
      }
      
      public function createIcon(param1:Boolean = true) : MovieClip
      {
         var _loc2_:SimpleWindow = _refinementManager.guiManager.getWindow(GuiConstants.REFINEMENT_WINDOW);
         var _loc3_:Bitmap = finisher.getEmbeddedBitmap(this._iconResKey);
         var _loc4_:MovieClip = new MovieClip();
         _loc4_.addChild(_loc3_);
         _loc4_.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         _loc4_.x = _loc2_.parent.mouseX - _loc4_.width / 2;
         _loc4_.y = _loc2_.parent.mouseY - _loc4_.height / 2;
         _loc2_.parent.addChild(_loc4_);
         if(param1)
         {
            _loc4_.alpha = 0;
            TweenLite.to(_loc4_,0.25,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
         return _loc4_;
      }
      
      private function onResetIcon(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         MovieClipUtils.removeDisplayObject(param1);
      }
      
      public function setAmmount(param1:int) : void
      {
         labelAmmount.setText(param1.toString());
      }
   }
}

