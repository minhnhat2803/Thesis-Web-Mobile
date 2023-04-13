import axios from 'axios';

const BASE_URL = 'http://localhost:8080/';

export const scanImage = async(imageSrc) => {
    const res = await axios.post(`${BASE_URL}scan/`, {imageSrc});
    return res
}

