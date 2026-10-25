package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightBoosterInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightBoosterInfoCommand;
      
      public var option3:EternalBlacklightBoosterCommand;
      
      public var skillPointInfo:EternalBlacklightSkillPointInfoCommand;
      
      public var currentBooster:Vector.<EternalBlacklightBoosterCommand>;
      
      public var option2:EternalBlacklightBoosterCommand;
      
      public var option1:EternalBlacklightBoosterCommand;
      
      public function EternalBlacklightBoosterInfoCommand(param1:Vector.<EternalBlacklightBoosterCommand> = null, param2:EternalBlacklightBoosterCommand = null, param3:EternalBlacklightBoosterCommand = null, param4:EternalBlacklightBoosterCommand = null, param5:EternalBlacklightSkillPointInfoCommand = null)
      {
         super();
         if(param4 == null)
         {
            this.option3 = new EternalBlacklightBoosterCommand();
         }
         else
         {
            this.option3 = param4;
         }
         if(param5 == null)
         {
            this.skillPointInfo = new EternalBlacklightSkillPointInfoCommand();
         }
         else
         {
            this.skillPointInfo = param5;
         }
         if(param1 == null)
         {
            this.currentBooster = new Vector.<EternalBlacklightBoosterCommand>();
         }
         else
         {
            this.currentBooster = param1;
         }
         if(param3 == null)
         {
            this.option2 = new EternalBlacklightBoosterCommand();
         }
         else
         {
            this.option2 = param3;
         }
         if(param2 == null)
         {
            this.option1 = new EternalBlacklightBoosterCommand();
         }
         else
         {
            this.option1 = param2;
         }
      }
      
      public static function get instance() : EternalBlacklightBoosterInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightBoosterInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1587;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EternalBlacklightBoosterCommand = null;
         this.option3 = EternalBlacklightBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option3)
         {
            this.option3.read(param1);
         }
         this.skillPointInfo = EternalBlacklightSkillPointInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.skillPointInfo)
         {
            this.skillPointInfo.read(param1);
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
            _loc4_ = EternalBlacklightBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.currentBooster.push(_loc4_);
            _loc2_++;
         }
         this.option2 = EternalBlacklightBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option2)
         {
            this.option2.read(param1);
         }
         this.option1 = EternalBlacklightBoosterCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.option1)
         {
            this.option1.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EternalBlacklightBoosterCommand = null;
         param1.writeShort(-1587);
         if(null != this.option3)
         {
            this.option3.write(param1);
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
         param1.writeByte(this.currentBooster.length);
         for each(_loc2_ in this.currentBooster)
         {
            _loc2_.write(param1);
         }
         if(null != this.option2)
         {
            this.option2.write(param1);
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
      }
   }
}

