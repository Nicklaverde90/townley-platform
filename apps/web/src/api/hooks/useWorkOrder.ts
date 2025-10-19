import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { axiosInstance } from '../axiosInstance'

export function useWorkOrder(recordNo: number){
  return useQuery({
    queryKey: ['workorder', recordNo],
    queryFn: async () => (await axiosInstance.get(`/workorders/${recordNo}`)).data,
    enabled: !!recordNo,
  })
}
export function useCreateWorkOrder(){
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (payload: any) => (await axiosInstance.post(`/workorders`, payload)).data,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['workorders'] })
  })
}
