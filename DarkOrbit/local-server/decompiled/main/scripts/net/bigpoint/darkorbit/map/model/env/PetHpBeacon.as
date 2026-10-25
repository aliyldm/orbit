package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class PetHpBeacon extends MapEntity
   {
      
      private static const RING_COLOR:uint = 65280;
      
      private static const RING_END_DIAMTER:int = 1050;
      
      private var _pulsingRingTrait:PulsingRingTrait;
      
      private var _displayTrait:UberDisplayTrait;
      
      public function PetHpBeacon(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"pet_beacon",UberAssetsLib.LIB_DEFAULT);
         this._displayTrait = getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         this._displayTrait.state.value = "hp";
         this._pulsingRingTrait = new PulsingRingTrait(true,RING_END_DIAMTER,RING_COLOR,false,2);
         addTrait(this._pulsingRingTrait);
         this._pulsingRingTrait.enable(RING_END_DIAMTER,RING_COLOR);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_AEGIS_HEALING_POD,true,false,this.position.x,this.position.y,true,true);
      }
      
      override public function deactivateEntity() : void
      {
         AudioManager.removeUniqueChannelById(InGameCatalog.SOUND_ID_AEGIS_HEALING_POD);
         this._pulsingRingTrait.disable();
         super.deactivateEntity();
      }
   }
}

