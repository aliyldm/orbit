package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TargetModule extends PlayerAttributeModule
   {
      
      private static var _instance:TargetModule;
      
      public var name:String = "";
      
      public var health:HealthModule;
      
      public var shipType:ShipIconModule;
      
      public function TargetModule(param1:ShipIconModule = null, param2:String = "", param3:HealthModule = null)
      {
         super();
         this.name = param2;
         if(param3 == null)
         {
            this.health = new HealthModule();
         }
         else
         {
            this.health = param3;
         }
         if(param1 == null)
         {
            this.shipType = new ShipIconModule();
         }
         else
         {
            this.shipType = param1;
         }
      }
      
      public static function get instance() : TargetModule
      {
         return _instance || (_instance = new TargetModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -3426;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.name = param1.readUTF();
         this.health = HealthModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.health)
         {
            this.health.read(param1);
         }
         this.shipType = ShipIconModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.shipType)
         {
            this.shipType.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-3426);
         super.write(param1);
         param1.writeUTF(this.name);
         if(null != this.health)
         {
            this.health.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.shipType)
         {
            this.shipType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

