package net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.commands
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.utils.DOBitmapAtlasResource;
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.FactoryViewProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.ViewCreateDTO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.AnimationVO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.AssetDescriptionVO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.AtlasResourceVO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.FactoryTweenVO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.IAnimatedViewContainer;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.StandartViewContainer;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class CreateMapAssetViewCommand extends AsyncCommand
   {
      
      public function CreateMapAssetViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:AtlasResourceVO = null;
         var _loc7_:AssetDescriptionVO = null;
         var _loc8_:Dictionary = null;
         var _loc9_:Vector.<AnimationVO> = null;
         var _loc10_:AnimationVO = null;
         var _loc11_:IAnimatedViewContainer = null;
         var _loc12_:IDODisplayObject = null;
         var _loc13_:Object = null;
         var _loc14_:String = null;
         super.execute(param1);
         var _loc2_:ViewCreateDTO = param1.getBody() as ViewCreateDTO;
         var _loc3_:IDOSprite = _loc2_.viewBuilder.buildSprite();
         var _loc4_:Dictionary = new Dictionary();
         var _loc6_:DOTexturesProxy = facade.retrieveProxy(DOTexturesProxy.NAME) as DOTexturesProxy;
         for each(_loc7_ in _loc2_.assetDescriptionVOList)
         {
            _loc5_ = _loc2_.searchForAtlasResourceVO(_loc7_.atlas);
            switch(_loc7_.type)
            {
               case "textfield":
                  _loc12_ = _loc2_.viewBuilder.buildTextField();
                  break;
               default:
                  _loc12_ = _loc2_.viewBuilder.buildDisplayObject(_loc5_ ? _loc6_.getTextureResource(_loc5_.textureResource,_loc5_.atlasResources) : null,_loc7_.subTexture);
                  if(_loc12_ != null)
                  {
                     break;
                  }
                  continue;
            }
            _loc13_ = _loc7_.props;
            for(_loc14_ in _loc13_)
            {
               _loc12_[_loc14_] = _loc13_[_loc14_];
            }
            _loc7_.view = _loc12_;
            _loc4_[_loc7_.id] = _loc12_;
            _loc3_.do_addChild(_loc12_);
         }
         _loc8_ = new Dictionary();
         _loc9_ = new Vector.<AnimationVO>();
         for each(_loc10_ in _loc2_.animationVo)
         {
            this.setChildrenView(_loc10_.children,_loc4_);
            if(_loc10_.id)
            {
               _loc8_[_loc10_.id] = _loc10_;
            }
            _loc9_.push(_loc10_);
         }
         _loc11_ = new StandartViewContainer(_loc2_,_loc4_,_loc8_,_loc9_,_loc3_,_loc2_.assetDescriptionVOList);
         _loc2_.callback(_loc11_);
         commandComplete();
      }
      
      private function setChildrenView(param1:Vector.<Object>, param2:Dictionary) : void
      {
         var _loc4_:Object = null;
         var _loc6_:FactoryTweenVO = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:AnimationVO = null;
         var _loc3_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            if(_loc4_ is FactoryTweenVO)
            {
               _loc6_ = _loc4_ as FactoryTweenVO;
               _loc7_ = _loc6_.viewId.split(",");
               _loc8_ = int(_loc7_.length);
               if(_loc8_ > 1)
               {
                  _loc9_ = new Vector.<Object>();
                  _loc10_ = 0;
                  while(_loc10_ < _loc8_)
                  {
                     (_loc9_ as Vector.<Object>).push(param2[_loc7_[_loc10_]]);
                     _loc10_++;
                  }
                  _loc9_ = new FactoryViewProxy(_loc9_ as Vector.<Object>);
               }
               else
               {
                  _loc9_ = param2[_loc6_.viewId];
               }
               _loc6_.view = _loc9_;
            }
            else if(_loc4_ is AnimationVO)
            {
               _loc11_ = _loc4_ as AnimationVO;
               this.setChildrenView(_loc11_.children,param2);
            }
            _loc5_++;
         }
      }
   }
}

