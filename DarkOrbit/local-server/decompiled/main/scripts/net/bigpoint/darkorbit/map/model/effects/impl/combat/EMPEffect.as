package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class EMPEffect extends MapObjectEffect
   {
      
      public static const TYPE_NORMAL:String = "emp";
      
      public static const TYPE_EMPEROR:String = "emperor_emp";
      
      public static const TYPE_ULTIMATE:String = "utlimate_emp";
      
      public static const TYPE_ULTIMATE_EPEROR:String = "utlimate_emperor_emp";
      
      public static const TYPE_NUKE:String = "nuke";
      
      public static const TYPE_BURNING_TRAIL:String = "burning_trail";
      
      private static const TYPE_2_SOUND_ID:Object = {};
      
      TYPE_2_SOUND_ID[TYPE_ULTIMATE] = InGameCatalog.SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING;
      TYPE_2_SOUND_ID[TYPE_ULTIMATE_EPEROR] = InGameCatalog.SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING;
      TYPE_2_SOUND_ID[TYPE_NUKE] = InGameCatalog.SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING;
      
      private var _empType:String;
      
      public function EMPEffect(param1:MapEntity, param2:String)
      {
         super(EffectIDList.EMP,param1,NOT_PERSISTANT,null,InGameCatalog.SOUND_ID_SPEARHEAD_JAMX);
         this._empType = param2;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
      
      public function get empType() : String
      {
         return this._empType;
      }
      
      public function get soundID() : int
      {
         return int(TYPE_2_SOUND_ID[this._empType]) || InGameCatalog.SOUND_ID_EMP;
      }
   }
}

