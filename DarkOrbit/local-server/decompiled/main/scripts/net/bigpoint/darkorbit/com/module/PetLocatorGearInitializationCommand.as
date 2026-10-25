package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetLocatorGearInitializationCommand implements IModule
   {
      
      private static var _instance:PetLocatorGearInitializationCommand;
      
      public var locatorType:PetGearTypeModule;
      
      public var possibleTargetValues:Vector.<int>;
      
      public function PetLocatorGearInitializationCommand(param1:PetGearTypeModule = null, param2:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.locatorType = new PetGearTypeModule();
         }
         else
         {
            this.locatorType = param1;
         }
         if(param2 == null)
         {
            this.possibleTargetValues = new Vector.<int>();
         }
         else
         {
            this.possibleTargetValues = param2;
         }
      }
      
      public static function get instance() : PetLocatorGearInitializationCommand
      {
         return _instance || (_instance = new PetLocatorGearInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 166;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.locatorType = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.locatorType)
         {
            this.locatorType.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.possibleTargetValues.length > 0)
         {
            this.possibleTargetValues.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 5 % 32 | _loc4_ >>> 32 - 5 % 32;
            this.possibleTargetValues.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(166);
         if(null != this.locatorType)
         {
            this.locatorType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.possibleTargetValues.length);
         for each(_loc2_ in this.possibleTargetValues)
         {
            param1.writeInt(_loc2_ >>> 5 % 32 | _loc2_ << 32 - 5 % 32);
         }
      }
   }
}

