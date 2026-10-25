package net.bigpoint.darkorbit.fui.components.buttons.checkbox
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.components.buttons.button.ButtonSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   
   public class CheckBoxSkin extends ButtonSkin implements ICheckBoxSkin
   {
      
      private static var _skinLayerDefintions:Dictionary = new Dictionary();
      
      _skinLayerDefintions[SkinLayerNames.NORMAL] = {};
      _skinLayerDefintions[SkinLayerNames.NORMAL_SELECTED] = {};
      _skinLayerDefintions[SkinLayerNames.OVER] = {};
      _skinLayerDefintions[SkinLayerNames.OVER_SELECTED] = {};
      _skinLayerDefintions[SkinLayerNames.CLICKED] = {};
      _skinLayerDefintions[SkinLayerNames.CLICKED_SELECTED] = {};
      _skinLayerDefintions[SkinLayerNames.DISABLED] = {};
      
      protected var _textStyleNameSelected:String;
      
      protected var _textStyleNameOverSelected:String;
      
      protected var _textStyleNameClickedSelected:String;
      
      protected var _textStyleNameDisabledSelected:String;
      
      public function CheckBoxSkin()
      {
         super();
      }
      
      override public function getSkinLayerDefintions() : Dictionary
      {
         return _skinLayerDefintions;
      }
      
      override public function init() : void
      {
         super.init();
         _resizablelayers = _resizablelayers.concat(new <String>[SkinLayerNames.NORMAL_SELECTED,SkinLayerNames.OVER_SELECTED]);
         if(_layers[SkinLayerNames.NORMAL_SELECTED])
         {
            addChild(_layers[SkinLayerNames.NORMAL_SELECTED]);
            hideState(SkinLayerNames.NORMAL_SELECTED);
         }
         if(_layers[SkinLayerNames.OVER_SELECTED])
         {
            addChild(_layers[SkinLayerNames.OVER_SELECTED]);
            hideState(SkinLayerNames.OVER_SELECTED);
         }
         var _loc1_:DisplayObject = getChildByName(TEXTFIELD_NAME);
         setChildIndex(_loc1_,numChildren - 1);
      }
      
      override protected function setCurrentSkinState(param1:String) : void
      {
         hideState(SkinLayerNames.NORMAL_SELECTED);
         hideState(SkinLayerNames.OVER_SELECTED);
         hideState(SkinLayerNames.CLICKED_SELECTED);
         hideState(SkinLayerNames.DISABLED_SELECTED);
         hideState(SkinLayerNames.NORMAL);
         hideState(SkinLayerNames.OVER);
         hideState(SkinLayerNames.CLICKED);
         hideState(SkinLayerNames.DISABLED);
         super.setCurrentSkinState(param1);
         switch(param1)
         {
            case SkinLayerNames.NORMAL_SELECTED:
               showState(SkinLayerNames.NORMAL_SELECTED);
               _assignTextStyleAndUpdateText_(this._textStyleNameSelected);
               break;
            case SkinLayerNames.OVER_SELECTED:
               showState(SkinLayerNames.OVER_SELECTED);
               _assignTextStyleAndUpdateText_(this._textStyleNameOverSelected);
               break;
            case SkinLayerNames.CLICKED_SELECTED:
               showState(SkinLayerNames.CLICKED_SELECTED);
               _assignTextStyleAndUpdateText_(this._textStyleNameClickedSelected);
               break;
            case SkinLayerNames.DISABLED_SELECTED:
               showState(SkinLayerNames.DISABLED_SELECTED);
               _assignTextStyleAndUpdateText_(this._textStyleNameDisabledSelected);
         }
      }
      
      public function set textStyleNameSelected(param1:String) : void
      {
         this._textStyleNameSelected = param1;
      }
      
      public function set textStyleNameOverSelected(param1:String) : void
      {
         this._textStyleNameOverSelected = param1;
      }
      
      public function set textStyleNameClickedSelected(param1:String) : void
      {
         this._textStyleNameClickedSelected = param1;
      }
      
      public function set textStyleNameDisabledSelected(param1:String) : void
      {
         this._textStyleNameDisabledSelected = param1;
      }
      
      override public function clone() : ISkin
      {
         var _loc1_:CheckBoxSkin = new CheckBoxSkin();
         _clone_(_loc1_,_skinLayerDefintions);
         this._cloneTextStyles(_loc1_);
         return _loc1_;
      }
      
      override protected function _cloneTextStyles(param1:ISkin) : void
      {
         super._cloneTextStyles(param1);
         var _loc2_:CheckBoxSkin = param1 as CheckBoxSkin;
         _loc2_.textStyleNameSelected = this._textStyleNameSelected;
         _loc2_.textStyleNameOverSelected = this._textStyleNameOverSelected;
         _loc2_.textStyleNameClickedSelected = this._textStyleNameClickedSelected;
         _loc2_.textStyleNameDisabledSelected = this._textStyleNameDisabledSelected;
      }
   }
}

