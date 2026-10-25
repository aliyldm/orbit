package net.bigpoint.darkorbit.fui.builder.xml.creators.skins
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.SkinRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.builder.xml.factories.SkinLayerFactory;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.ISkinLayer;
   
   public class AbstractSkinCreator extends AbstractCreator
   {
      
      private static var _layerNodenameToTextStyleHandlerMethodMapping:Dictionary = new Dictionary();
      
      public function AbstractSkinCreator()
      {
         super();
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.NORMAL] = this.handleSkinLayerNormalTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.OVER] = this.handleSkinLayerOverTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.CLICKED] = this.handleSkinLayerClickedTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.DISABLED] = this.handleSkinLayerDisabledTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.NORMAL_SELECTED] = this.handleSkinLayerNormalSelectedTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.OVER_SELECTED] = this.handleSkinLayerOverSelectedTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.CLICKED_SELECTED] = this.handleSkinLayerClickedSelectedTextstyleAttribute;
         _layerNodenameToTextStyleHandlerMethodMapping[SkinLayerNames.DISABLED_SELECTED] = this.handleSkinLayerDisabledSelectedTextstyleAttribute;
      }
      
      public function create(param1:XML) : ISkin
      {
         UISystem.log("You called an abstract method. Please override \'AbstractSkinCreator::createMethod(node)\' ",UISystem.LOG_LEVEL_WARN);
         return null;
      }
      
      protected function assignSkinStates(param1:XML, param2:ISkin, param3:Dictionary = null) : void
      {
         var _loc6_:XML = null;
         var _loc7_:ISkinLayer = null;
         var _loc8_:String = null;
         if(param3 == null)
         {
            param3 = param2.getSkinLayerDefintions();
         }
         var _loc4_:XMLList = param1.children();
         var _loc5_:String = AbstractCreator.getLibrary(param1);
         for each(_loc6_ in _loc4_)
         {
            _loc7_ = this.createSkinLayer(_loc6_,_loc5_);
            _loc8_ = _loc7_.name;
            if(param3[_loc8_])
            {
               param2.setSkinLayer(_loc8_,_loc7_ as DisplayObject);
            }
         }
         this.registerSkin(param1,param2);
      }
      
      protected function assignStateNames(param1:XML, param2:ISkin) : void
      {
         var _loc4_:XML = null;
         var _loc3_:XMLList = param1.child("layer");
         for each(_loc4_ in _loc3_)
         {
            param2.getSkinLayerDefintions()[_loc4_.text().toString()] = {};
         }
      }
      
      protected function registerSkin(param1:XML, param2:ISkin) : void
      {
         var _loc3_:String = param1.@name;
         if(_loc3_)
         {
            SkinRepository.getInstance().registerSkin(_loc3_,param2);
            param2.registerdName = _loc3_;
         }
         else
         {
            UISystem.log("No skinName has been defined. It´s needed to register it at the SkinRegistry.",UISystem.LOG_LEVEL_WARN);
         }
      }
      
      protected function createSkinLayer(param1:XML, param2:String) : ISkinLayer
      {
         return SkinLayerFactory.create(param1,param2);
      }
      
      protected function assignTextStyleStates(param1:XML, param2:ISkin) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Function = null;
         var _loc3_:XMLList = param1.child("layer");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.attribute("registeredTextStyleName");
            if(_loc5_.length > 0)
            {
               _loc6_ = _loc4_.text().toString();
               _loc7_ = _layerNodenameToTextStyleHandlerMethodMapping[_loc6_];
               if(_loc7_ != null)
               {
                  _loc7_(param2,_loc5_);
               }
               else
               {
                  UISystem.log("Couldn´t invoke " + _loc5_ + "",UISystem.LOG_LEVEL_WARN);
               }
            }
         }
      }
      
      protected function handleSkinLayerNormalTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleName = param2;
      }
      
      protected function handleSkinLayerOverTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameOver = param2;
      }
      
      protected function handleSkinLayerClickedTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameClicked = param2;
      }
      
      protected function handleSkinLayerDisabledTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameDisabled = param2;
      }
      
      protected function handleSkinLayerNormalSelectedTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameSelected = param2;
      }
      
      protected function handleSkinLayerOverSelectedTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameOverSelected = param2;
      }
      
      protected function handleSkinLayerClickedSelectedTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameClickedSelected = param2;
      }
      
      protected function handleSkinLayerDisabledSelectedTextstyleAttribute(param1:Object, param2:Object) : void
      {
         param1.textStyleNameDisabledSelected = param2;
      }
   }
}

