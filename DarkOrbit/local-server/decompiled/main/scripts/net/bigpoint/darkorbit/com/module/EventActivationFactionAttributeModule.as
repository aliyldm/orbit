package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EventActivationFactionAttributeModule extends EventActivationAttributeModule
   {
      
      private static var _instance:EventActivationFactionAttributeModule;
      
      public var faction:FactionModule;
      
      public function EventActivationFactionAttributeModule(param1:FactionModule = null)
      {
         super();
         if(param1 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param1;
         }
      }
      
      public static function get instance() : EventActivationFactionAttributeModule
      {
         return _instance || (_instance = new EventActivationFactionAttributeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -3281;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-3281);
         super.write(param1);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

