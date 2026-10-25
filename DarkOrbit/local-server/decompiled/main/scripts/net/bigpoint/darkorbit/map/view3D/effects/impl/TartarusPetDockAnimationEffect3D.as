package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import mx.effects.easing.Cubic;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.TartarusPetDockAnimationEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class TartarusPetDockAnimationEffect3D implements IDisposable
   {
      
      private static const FINAL_X:Number = 0;
      
      private static const FINAL_Y:Number = -6;
      
      private static const FINAL_Z:Number = -4.5;
      
      private static const DOCKED:String = "DOCKED";
      
      private static const DOCKING_ANIMATION:String = "DOCKING_ANIMATION";
      
      private var _ship:Ship;
      
      private var _ship3D:MapUberAsset3D;
      
      private var _oldPet:Pet;
      
      private var _pet3D:UberAsset3D;
      
      private var _oldPet3D:MapUberAsset3D;
      
      private var _mapView:MapView3D;
      
      private var _petDesignId:String;
      
      private var _effect:TartarusPetDockAnimationEffect;
      
      private var _petAnimationStatus:String;
      
      public function TartarusPetDockAnimationEffect3D(param1:MapView3D, param2:TartarusPetDockAnimationEffect)
      {
         super();
         this._ship = param2.source as Ship;
         this._mapView = param1;
         this._oldPet = this._ship.pet;
         this._petDesignId = param2.petDesignId;
         this._effect = param2;
         this._effect.onDesignSetAdded.add(this.start);
         this._ship.shipPatternChanged.add(this.start);
         if(this._ship.hasDesignSet.value)
         {
            this.start();
         }
      }
      
      private function start() : void
      {
         var _loc1_:UberDisplayTrait = null;
         this._effect.onDesignSetAdded.remove(this.start);
         if(this._oldPet == null)
         {
            this._petAnimationStatus = DOCKED;
         }
         else
         {
            _loc1_ = this._oldPet.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            this._oldPet3D = this._mapView.mainContainer.getViewByTrait(_loc1_) as MapUberAsset3D;
            if(this._oldPet3D)
            {
               this._petAnimationStatus = DOCKING_ANIMATION;
            }
            else
            {
               this._petAnimationStatus = DOCKED;
            }
         }
         this._pet3D = new UberAsset3D(UberAssetsLib.instance.getDescriptor(this._petDesignId + "_noAnimation",UberAssetsLib.LIB_SHIPS).display3D[0]);
         this._pet3D.ready.add(this.handleUberReady);
         this._ship3D = this._mapView.mainContainer.getViewByTrait(this._ship.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
      }
      
      private function handleUberReady() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._pet3D.uberMeshes.length)
         {
            this._pet3D.uberMeshes[_loc1_].mesh.shaderParams.xRayAlpha = 0;
            _loc1_++;
         }
         if(this._petAnimationStatus == DOCKING_ANIMATION)
         {
            this._pet3D.position = this._ship3D.inverseSceneTransform.transformVector(this._oldPet3D.position);
            this._pet3D.rotationY = this._oldPet.rotation.degrees - this._ship.rotation.degrees;
            this._oldPet3D.visible = false;
            this.petAnimation();
         }
         else
         {
            this._pet3D.playAnimation("close");
         }
         if(this._ship3D.finishedLoading)
         {
            this.addPetToShip();
         }
         else
         {
            this._ship3D.ready.addOnce(this.addPetToShip);
         }
      }
      
      private function addPetToShip() : void
      {
         this._pet3D.scaleX = this._pet3D.scaleY = this._pet3D.scaleZ = 1 / this._ship3D.viewRoot.scaleX;
         this._ship3D.viewRoot.addChild(this._pet3D);
      }
      
      private function petAnimation() : void
      {
         if(this._pet3D != null)
         {
            this._pet3D.playAnimation("close");
            TweenMax.to(this._pet3D,1,{
               "bezier":[{
                  "x":0,
                  "y":250 / this._ship3D.viewRoot.scaleX,
                  "z":-300 / this._ship3D.viewRoot.scaleX
               },{
                  "x":0,
                  "y":-6 / this._ship3D.viewRoot.scaleX,
                  "z":-300 / this._ship3D.viewRoot.scaleX
               },{
                  "x":FINAL_X / this._ship3D.viewRoot.scaleX,
                  "y":FINAL_Y / this._ship3D.viewRoot.scaleX,
                  "z":FINAL_Z / this._ship3D.viewRoot.scaleX
               }],
               "rotationY":0,
               "rotationX":0,
               "rotationZ":0,
               "ease":Cubic.easeIn
            });
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._effect.onDesignSetAdded.remove(this.start);
         this._ship.shipPatternChanged.remove(this.start);
         if(this._ship3D)
         {
            this._ship3D.ready.remove(this.addPetToShip);
         }
         if(this._pet3D)
         {
            this._pet3D.ready.remove(this.handleUberReady);
            TweenMax.killTweensOf(this._pet3D);
            this._pet3D.playAnimation("open");
            if(this._pet3D.parent)
            {
               this._pet3D.parent.removeChild(this._pet3D);
            }
         }
      }
   }
}

