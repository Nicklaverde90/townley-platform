import axios from 'axios'
export const axiosInstance = axios.create({ baseURL: '/api', withCredentials: true })
axiosInstance.interceptors.response.use(r=>r, async (err)=> Promise.reject(err))
