package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateBoosterInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateBoosterInfoCommand;
      
      public var option2:EternalGateBoosterCommand;
      
      public var skillPointInfo:EternalGateSkillPointInfoCommand;
      
      public var option1:EternalGateBoosterCommand;
      
      public var currentBooster:Vector.<EternalGateBoosterCommand>;
      
      public var option3:EternalGateBoosterCommand;
      
      public function EternalGateBoosterInfoCommand(param1:Vector.<EternalGateBoosterCommand> = null, param2:EternalGateBoosterCommand = null, param3:EternalGateBoosterCommand = null, param4:EternalGateBoosterCommand = null, param5:EternalGateSkillPointInfoCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.option2 = new EternalGateBoosterCommand();
         }
         else
         {
            this.option2 = param3;
         }
         if(param5 == null)
         {
            this.skillPointInfo = new EternalGateSkillPointInfoCommand();
         }
         else
         {
            this.skillPointInfo = param5;
         }
         if(param2 == null)
         {
            this.option1 = new EternalGateBoosterCommand();
         }
         else
         {
            this.option1 = param2;
         }
         if(param1 == null)
         {
            this.currentBooster = new Vector.<EternalGateBoosterCommand>();
         }
         else
         {
            this.currentBooster = param1;
         }
         if(param4 == null)
         {
            this.option3 = new EternalGateBoosterCommand();
         }
         else
         {
            this.option3 = param4;
         }
      }
      
      public static function get instance() : EternalGateBoosterInfoCommand
      {
         return _instance || (_instance = new EternalGateBoosterInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7278;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EternalGateBoosterCommand = null;
         this.option2 = EternalGateBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option2)
         {
            this.option2.read(param1);
         }
         this.skillPointInfo = EternalGateSkillPointInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.skillPointInfo)
         {
            this.skillPointInfo.read(param1);
         }
         this.option1 = EternalGateBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option1)
         {
            this.option1.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.currentBooster.length > 0)
         {
            this.currentBooster.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EternalGateBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.currentBooster.push(_loc4_);
            _loc2_++;
         }
         this.option3 = EternalGateBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option3)
         {
            this.option3.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EternalGateBoosterCommand = null;
         param1.writeShort(-7278);
         if(null != this.option2)
         {
            this.option2.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.skillPointInfo)
         {
            this.skillPointInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.option1)
         {
            this.option1.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.currentBooster.length);
         for each(_loc2_ in this.currentBooster)
         {
            _loc2_.write(param1);
         }
         if(null != this.option3)
         {
            this.option3.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

