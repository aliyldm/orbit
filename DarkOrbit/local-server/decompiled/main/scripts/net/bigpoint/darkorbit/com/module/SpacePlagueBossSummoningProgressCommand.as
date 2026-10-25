package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpacePlagueBossSummoningProgressCommand implements IModule
   {
      
      private static var _instance:SpacePlagueBossSummoningProgressCommand;
      
      public static const SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_1:int = 0;
      
      public static const SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_2:int = 1;
      
      public static const SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_3:int = 2;
      
      public static const SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE__MAX:int = 3;
      
      public var minionsCounter:SpacePlagueCounterDataModule;
      
      public var bossCounter:SpacePlagueCounterDataModule;
      
      public var waveGroup:int = 0;
      
      public function SpacePlagueBossSummoningProgressCommand(param1:int = 0, param2:SpacePlagueCounterDataModule = null, param3:SpacePlagueCounterDataModule = null)
      {
         super();
         if(param2 == null)
         {
            this.minionsCounter = new SpacePlagueCounterDataModule();
         }
         else
         {
            this.minionsCounter = param2;
         }
         if(param3 == null)
         {
            this.bossCounter = new SpacePlagueCounterDataModule();
         }
         else
         {
            this.bossCounter = param3;
         }
         this.waveGroup = param1;
      }
      
      public static function get instance() : SpacePlagueBossSummoningProgressCommand
      {
         return _instance || (_instance = new SpacePlagueBossSummoningProgressCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6643;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.minionsCounter = SpacePlagueCounterDataModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.minionsCounter)
         {
            this.minionsCounter.read(param1);
         }
         this.bossCounter = SpacePlagueCounterDataModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.bossCounter)
         {
            this.bossCounter.read(param1);
         }
         this.waveGroup = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6643);
         if(null != this.minionsCounter)
         {
            this.minionsCounter.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.bossCounter)
         {
            this.bossCounter.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.waveGroup);
      }
   }
}

