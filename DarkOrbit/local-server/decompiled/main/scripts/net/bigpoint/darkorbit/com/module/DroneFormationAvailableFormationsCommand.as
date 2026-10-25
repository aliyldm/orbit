package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DroneFormationAvailableFormationsCommand implements IModule
   {
      
      private static var _instance:DroneFormationAvailableFormationsCommand;
      
      public var availableFormations:Vector.<int>;
      
      public function DroneFormationAvailableFormationsCommand(param1:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.availableFormations = new Vector.<int>();
         }
         else
         {
            this.availableFormations = param1;
         }
      }
      
      public static function get instance() : DroneFormationAvailableFormationsCommand
      {
         return _instance || (_instance = new DroneFormationAvailableFormationsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 258;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.availableFormations.length > 0)
         {
            this.availableFormations.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 14 % 32 | _loc4_ << 32 - 14 % 32;
            this.availableFormations.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(258);
         param1.writeByte(this.availableFormations.length);
         for each(_loc2_ in this.availableFormations)
         {
            param1.writeInt(_loc2_ << 14 % 32 | _loc2_ >>> 32 - 14 % 32);
         }
      }
   }
}

