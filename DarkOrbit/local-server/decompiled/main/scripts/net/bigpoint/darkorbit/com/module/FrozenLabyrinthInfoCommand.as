package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthInfoCommand implements IModule
   {
      
      private static var _instance:FrozenLabyrinthInfoCommand;
      
      public var rankInfo:FrozenLabyrinthRankInfoCommand;
      
      public var labyrinthKeys:int = 0;
      
      public var timeInfo:FrozenLabyrinthTimeInfoCommand;
      
      public function FrozenLabyrinthInfoCommand(param1:int = 0, param2:FrozenLabyrinthTimeInfoCommand = null, param3:FrozenLabyrinthRankInfoCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.rankInfo = new FrozenLabyrinthRankInfoCommand();
         }
         else
         {
            this.rankInfo = param3;
         }
         this.labyrinthKeys = param1;
         if(param2 == null)
         {
            this.timeInfo = new FrozenLabyrinthTimeInfoCommand();
         }
         else
         {
            this.timeInfo = param2;
         }
      }
      
      public static function get instance() : FrozenLabyrinthInfoCommand
      {
         return _instance || (_instance = new FrozenLabyrinthInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12606;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rankInfo = FrozenLabyrinthRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rankInfo)
         {
            this.rankInfo.read(param1);
         }
         this.labyrinthKeys = param1.readInt();
         this.labyrinthKeys = this.labyrinthKeys >>> 1 % 32 | this.labyrinthKeys << 32 - 1 % 32;
         this.timeInfo = FrozenLabyrinthTimeInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timeInfo)
         {
            this.timeInfo.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12606);
         if(null != this.rankInfo)
         {
            this.rankInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.labyrinthKeys << 1 % 32 | this.labyrinthKeys >>> 32 - 1 % 32);
         if(null != this.timeInfo)
         {
            this.timeInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

