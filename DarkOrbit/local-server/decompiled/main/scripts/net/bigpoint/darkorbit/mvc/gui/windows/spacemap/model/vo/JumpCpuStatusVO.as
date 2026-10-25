package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo
{
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public class JumpCpuStatusVO
   {
      
      private var _cpuEquipped:Boolean;
      
      private var _spaceMapStations:Vector.<SpaceMapStationInfoVO>;
      
      private var _onSpaceMap:Boolean;
      
      public function JumpCpuStatusVO(param1:Boolean, param2:Vector.<SpaceMapStationInfoVO>, param3:Boolean)
      {
         super();
         this._cpuEquipped = param1;
         this._spaceMapStations = param2;
         this._onSpaceMap = param3;
      }
      
      public function get cpuEquipped() : Boolean
      {
         return this._cpuEquipped;
      }
      
      public function get spaceMapStations() : Vector.<SpaceMapStationInfoVO>
      {
         return this._spaceMapStations;
      }
      
      public function get onSpaceMap() : Boolean
      {
         return this._onSpaceMap;
      }
   }
}

