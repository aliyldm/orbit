package net.bigpoint.darkorbit.map.model.env.collectable
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.core.MapEntityContainer;
   import net.bigpoint.darkorbit.map.model.traits.LabelTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Collectable extends MapEntity
   {
      
      public const clicked:ISignal = new Signal(Collectable);
      
      public const collected:ISignal = new Signal();
      
      private var _soundId:int = 3;
      
      private var _settings:BindableBoolean;
      
      private var _collectableTraits:Vector.<EntityTraitBase>;
      
      private var _hash:String;
      
      private var _isCollected:Boolean = false;
      
      private var _fresh:Boolean = false;
      
      public function Collectable(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:BindableBoolean = null)
      {
         super(Map.getNextIdForHash(param2),new BindablePointLite(param3,param4));
         this._hash = param2;
         this._fresh = param5;
         this._settings = param6;
         if(UberAssetsLib.instance.getDescriptor(param1,UberAssetsLib.LIB_COLLECTABLES) != null)
         {
            UberAssetsLib.instance.fillTraits(this,param1,UberAssetsLib.LIB_COLLECTABLES,null,this.handleClicked);
         }
         else
         {
            UberAssetsLib.instance.fillTraits(this,"_placeholder",UberAssetsLib.LIB_COLLECTABLES,null,this.handleClicked);
            addTrait(new LabelTrait("{" + param1 + "}",0,15));
         }
         this._collectableTraits = traits.concat();
      }
      
      public function get hash() : String
      {
         return this._hash;
      }
      
      public function get isCollected() : Boolean
      {
         return this._isCollected;
      }
      
      public function get fresh() : Boolean
      {
         return this._fresh;
      }
      
      override public function activateEntity(param1:MapEntityContainer) : void
      {
         if(this._settings)
         {
            this._settings.changed.add(this.updateTraits);
         }
         this.updateTraits();
         super.activateEntity(param1);
      }
      
      override public function deactivateEntity() : void
      {
         if(this._settings)
         {
            this._settings.changed.remove(this.updateTraits);
         }
         super.deactivateEntity();
      }
      
      public function collect() : void
      {
         this._isCollected = true;
         this.collected.dispatch();
      }
      
      private function updateTraits() : void
      {
         var _loc1_:EntityTraitBase = null;
         if(this._settings == null || this._settings.value)
         {
            for each(_loc1_ in this._collectableTraits)
            {
               addTrait(_loc1_);
            }
         }
         else
         {
            for each(_loc1_ in this._collectableTraits)
            {
               removeTrait(_loc1_);
            }
         }
      }
      
      private function handleClicked() : void
      {
         ScreenManager.getInstance().eventManager.moveHeroToCordinates(x,y,this);
         this.clicked.dispatch(this);
      }
      
      public function get soundId() : int
      {
         return this._soundId;
      }
   }
}

